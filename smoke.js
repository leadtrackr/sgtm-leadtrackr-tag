const { run } = require('./harness');
const assert = require('assert');
let pass = 0, fail = 0;
function t(name, fn) {
  try { fn(); pass++; console.log('  ok  ' + name); }
  catch (e) { fail++; console.log('FAIL  ' + name + '\n      ' + e.message); }
}

/* ---------- Channel Flow: first visit from Google Ads ---------- */
t('pageview: first visit with gclid records google/cpc and writes both cookies', () => {
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/lp?gclid=abc123', page_referrer: '' },
    cookies: {}
  });
  assert.strictEqual(r.setCookies.length, 2);
  const flow = JSON.parse(r.setCookies[0].value);
  assert.strictEqual(r.setCookies[0].name, 'lt_channelflow');
  assert.deepStrictEqual(flow[0].ch, { s: 'google', m: 'cpc' });
  assert.strictEqual(flow[0].lp, '/lp');
  assert.strictEqual(r.setCookies[0].options['max-age'], 395 * 86400);
  assert.strictEqual(r.setCookies[1].name, 'lt_session');
  assert.strictEqual(r.setCookies[1].options['max-age'], 1800);
  assert.strictEqual(r.setCookies[0].options.httpOnly, false);
  assert.strictEqual(r.success, 1);
});

t('pageview: utm parameters win over the click id', () => {
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/?utm_source=nieuwsbrief&utm_medium=email&gclid=x' }
  });
  assert.deepStrictEqual(JSON.parse(r.setCookies[0].value)[0].ch, { s: 'nieuwsbrief', m: 'email' });
});

t('pageview: same session with no campaign signal does not add an entry', () => {
  const existing = [{ t: 1, ch: { s: 'google', m: 'cpc' }, lp: '/lp' }];
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/pricing', page_referrer: 'https://www.example.nl/lp' },
    cookies: { lt_channelflow: JSON.stringify(existing), lt_session: '1' }
  });
  assert.strictEqual(JSON.parse(r.setCookies[0].value).length, 1);
});

t('pageview: expired session adds a direct entry', () => {
  const existing = [{ t: 1, ch: { s: 'google', m: 'cpc' } }];
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/pricing', page_referrer: 'https://www.example.nl/lp' },
    cookies: { lt_channelflow: JSON.stringify(existing) }
  });
  const flow = JSON.parse(r.setCookies[0].value);
  assert.strictEqual(flow.length, 2);
  assert.deepStrictEqual(flow[1].ch, { s: 'direct', m: 'none' });
});

t('pageview: search engine referrer resolves to organic on any country domain', () => {
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/', page_referrer: 'https://www.google.co.uk/' }
  });
  assert.deepStrictEqual(JSON.parse(r.setCookies[0].value)[0].ch, { s: 'google', m: 'organic' });
});

t('pageview: other website referrer resolves to referral', () => {
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/', page_referrer: 'https://www.partner.nl/blog' }
  });
  assert.deepStrictEqual(JSON.parse(r.setCookies[0].value)[0].ch, { s: 'www.partner.nl', m: 'referral' });
});

t('pageview: carried-over click id behind an internal referrer is not a new paid touch', () => {
  const existing = [{ t: 1, ch: { s: 'direct', m: 'none' } }];
  const r = run({ tagType: 'pageview' }, {
    eventData: {
      page_location: 'https://www.example.nl/pricing?gclid=carried',
      page_referrer: 'https://shop.example.nl/lp'
    },
    cookies: { lt_channelflow: JSON.stringify(existing), lt_session: '1' }
  });
  assert.strictEqual(JSON.parse(r.setCookies[0].value).length, 1);
});

t('pageview: legacy cookie entries survive the upgrade', () => {
  const legacy = [{ timestamp: 1700000000000, channel: { source: 'google', medium: 'cpc', campaign: 'zomer' } }];
  const r = run({ tagType: 'pageview' }, {
    eventData: { page_location: 'https://www.example.nl/' },
    cookies: { lt_channelflow: JSON.stringify(legacy), lt_session: '1' }
  });
  const flow = JSON.parse(r.setCookies[0].value);
  assert.deepStrictEqual(flow[0], { t: 1700000000000, ch: { s: 'google', m: 'cpc', cm: 'zomer' } });
});

t('pageview: custom session timeout and httpOnly are honoured', () => {
  const r = run({ tagType: 'pageview', sessionTimeoutMinutes: '60', useHttpOnlyCookie: true,
                  overrideCookieDomain: true, cookieDomain: '.example.nl' }, {
    eventData: { page_location: 'https://www.example.nl/' }
  });
  assert.strictEqual(r.setCookies[1].options['max-age'], 3600);
  assert.strictEqual(r.setCookies[0].options.httpOnly, true);
  assert.strictEqual(r.setCookies[0].options.domain, '.example.nl');
});

/* ---------- Lead ---------- */
const leadEvent = {
  page_location: 'https://www.example.nl/contact?gclid=urlgclid&fbclid=FBCL1',
  page_referrer: 'https://www.example.nl/',
  event_id: 'evt-42',
  client_id: '111.222',
  ga_session_id: '1780000000',
  ip_override: '203.0.113.9, 70.41.3.18',
  user_agent: 'Mozilla/5.0 (Macintosh)',
  user_data: {
    email_address: 'jane@example.com',
    phone_number: '+31612345678',
    sha256_email_address: 'deadbeef',
    address: [{ first_name: 'Jane', last_name: 'Smith' }]
  },
  consent_state: { ad_storage: true, analytics_storage: true, ad_user_data: false }
};

t('lead: authenticated endpoint and X-API-Key when a key is set', () => {
  const r = run({ tagType: 'lead', projectId: 'p1', apiKey: 'sk_live_x', formName: 'Contact' },
    { eventData: leadEvent });
  assert.strictEqual(r.requests[0].url, 'https://app.leadtrackr.io/api/leads/createServerSideLead');
  assert.strictEqual(r.requests[0].options.headers['X-API-Key'], 'sk_live_x');
  assert.strictEqual(r.success, 1);
});

t('lead: still posts to the authenticated endpoint without a key, header omitted', () => {
  const r = run({ tagType: 'lead', projectId: 'p1', formName: 'Contact' }, { eventData: leadEvent });
  assert.strictEqual(r.requests[0].url, 'https://app.leadtrackr.io/api/leads/createServerSideLead');
  assert.strictEqual(r.requests[0].options.headers['X-API-Key'], undefined);
});

t('lead: userData is always in the body, since the endpoint rejects it otherwise', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', autoMapUserData: false }, {
    eventData: { page_location: 'https://www.example.nl/c?gclid=x' }
  }).requests[0].body;
  assert.strictEqual(typeof b.userData, 'object');
  assert.notStrictEqual(b.userData, null);
});

t('lead: user data is auto-mapped and hashed fields are skipped', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent }).requests[0].body;
  assert.deepStrictEqual(b.userData, {
    firstName: 'Jane', lastName: 'Smith', email: 'jane@example.com', phone: '+31612345678'
  });
});

t('lead: a manual user data row overrides the auto-mapped value, a blank row does not', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', userDataFields: [
    { key: 'email', value: 'override@example.com' },
    { key: 'companyName', value: '' }
  ] }, { eventData: leadEvent }).requests[0].body;
  assert.strictEqual(b.userData.email, 'override@example.com');
  assert.strictEqual(b.userData.firstName, 'Jane');
  assert.strictEqual(b.userData.companyName, undefined);
});

t('lead: event_id becomes uniqueEventId when deduplication is on', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', dedupEnabled: true }, { eventData: leadEvent }).requests[0].body;
  assert.strictEqual(b.formData.uniqueEventId, 'evt-42');
});

t('lead: an explicit unique event id wins over the automatic one', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', dedupEnabled: true, uniqueEventId: 'mine' },
    { eventData: leadEvent }).requests[0].body;
  assert.strictEqual(b.formData.uniqueEventId, 'mine');
});

t('lead: deduplication off leaves the automatic id out', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', dedupEnabled: false }, { eventData: leadEvent }).requests[0].body;
  assert.strictEqual(b.formData.uniqueEventId, undefined);
});

t('lead: device data uses ipAddress and the first forwarded ip', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent }).requests[0].body;
  assert.deepStrictEqual(b.deviceData, { ipAddress: '203.0.113.9', userAgent: 'Mozilla/5.0 (Macintosh)' });
});

t('lead: no ip is sent when the event has none, instead of 127.0.0.1', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' },
    { eventData: { page_location: 'https://www.example.nl/c' }, headers: { 'user-agent': 'UA' } }).requests[0].body;
  assert.strictEqual(b.deviceData.ipAddress, undefined);
  assert.strictEqual(b.deviceData.userAgent, 'UA');
});

t('lead: the legacy ipAdress override key is still read', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', customDeviceData: true,
    deviceData: [{ key: 'ipAdress', value: '198.51.100.7' }] }, { eventData: leadEvent }).requests[0].body;
  assert.strictEqual(b.deviceData.ipAddress, '198.51.100.7');
});

t('lead: url click id beats the cookie, cookie click ids are unwrapped', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: leadEvent,
    cookies: {
      _gcl_aw: 'GCL.1700000000.cookiegclid',
      FPGCLGB: 'GCL.1700000000.wbraidvalue',
      _gcl_ag: 'GCL.1700000000.kGBRAIDVALUE$i1',
      _uetmsclkid: '_uet561f11',
      _ttp: 'ttpvalue',
      _ga: 'GA1.1.9999.8888'
    }
  }).requests[0].body;
  assert.strictEqual(b.attributionData.gclid, 'urlgclid');
  assert.strictEqual(b.attributionData.wbraid, 'wbraidvalue');
  assert.strictEqual(b.attributionData.gbraid, 'GBRAIDVALUE');
  assert.strictEqual(b.attributionData.msclkid, '561f11');
  assert.strictEqual(b.attributionData.ttp, 'ttpvalue');
  assert.strictEqual(b.attributionData.cid, '111.222');
  assert.strictEqual(b.attributionData.sid, '1780000000');
});

t('lead: a browser-format gclid starting with k is not mistaken for the server format', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: { page_location: 'https://www.example.nl/c', user_data: { email_address: 'a@b.nl' } },
    cookies: { _gcl_aw: 'GCL.1700000000.kAbCdEf' }
  }).requests[0].body;
  assert.strictEqual(b.attributionData.gclid, 'kAbCdEf');
});

t('lead: fbc is built from fbclid when the cookie is absent or stale', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent, now: 1780000000000 }).requests[0].body;
  assert.strictEqual(b.attributionData.fbc, 'fb.1.1780000000000.FBCL1');
});

t('lead: an existing matching _fbc cookie is left alone', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: leadEvent, cookies: { _fbc: 'fb.1.1700000000000.FBCL1' }
  }).requests[0].body;
  assert.strictEqual(b.attributionData.fbc, 'fb.1.1700000000000.FBCL1');
});

t('lead: consent state and conversion page ride along', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent }).requests[0].body;
  assert.deepStrictEqual(b.attributionData.consent,
    { ad_storage: 'granted', analytics_storage: 'granted', ad_user_data: 'denied' });
  assert.strictEqual(b.attributionData.conversionPage, 'www.example.nl/contact');
});

t('lead: x-ga-gcs is used when consent_state is absent', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: { page_location: 'https://www.example.nl/c', email: 'a@b.nl', 'x-ga-gcs': 'G101' }
  }).requests[0].body;
  assert.deepStrictEqual(b.attributionData.consent, { ad_storage: 'denied', analytics_storage: 'granted' });
});

t('lead: channel flow is read from the cookie', () => {
  const flow = [{ t: 1, ch: { s: 'google', m: 'cpc' } }];
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: leadEvent, cookies: { lt_channelflow: JSON.stringify(flow) }
  }).requests[0].body;
  assert.deepStrictEqual(b.channelFlow, flow);
});

t('lead: empty attribution and user data keys are left out of the payload', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: { page_location: 'https://www.example.nl/c', email: 'a@b.nl' }
  }).requests[0].body;
  assert.strictEqual('twclid' in b.attributionData, false);
  assert.strictEqual('gclid' in b.attributionData, false);
  assert.strictEqual(b.channelFlow, undefined);
});

/* ---------- Consent gate ---------- */
t('consent gate: lead is aborted when required marketing consent is denied', () => {
  const r = run({ tagType: 'lead', projectId: 'p1', consentRequirement: 'ad_storage' }, {
    eventData: { page_location: 'https://www.example.nl/c', email: 'a@b.nl',
                 consent_state: { ad_storage: false, analytics_storage: true } }
  });
  assert.strictEqual(r.requests.length, 0);
  assert.strictEqual(r.success, 1);
});

t('consent gate: channel flow is aborted when analytics consent is denied', () => {
  const r = run({ tagType: 'pageview', consentRequirement: 'analytics_storage' }, {
    eventData: { page_location: 'https://www.example.nl/', 'x-ga-gcs': 'G100' }
  });
  assert.strictEqual(r.setCookies.length, 0);
});

t('consent gate: a container without consent mode still runs', () => {
  const r = run({ tagType: 'pageview', consentRequirement: 'analytics_storage' }, {
    eventData: { page_location: 'https://www.example.nl/' }
  });
  assert.strictEqual(r.setCookies.length, 2);
});

t('gtm-msr preview requests are skipped', () => {
  const r = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: { page_location: 'https://gtm-msr.appspot.com/render?id=1' }
  });
  assert.strictEqual(r.requests.length, 0);
  assert.strictEqual(r.success, 1);
});

t('lead: a non-2xx response reports failure', () => {
  const r = run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent, statusCode: 401 });
  assert.strictEqual(r.failure, 1);
});


/* ---------- Unique Identifier ---------- */
t('lead: unique identifier row lands at the payload root, not inside userData', () => {
  const b = run({ tagType: 'lead', projectId: 'p1', userDataFields: [
    { key: 'uniqueIdentifier', value: 'crm-789' },
    { key: 'email', value: 'a@b.nl' }
  ] }, { eventData: leadEvent }).requests[0].body;
  assert.strictEqual(b.uniqueIdentifier, 'crm-789');
  assert.strictEqual(b.userData.uniqueIdentifier, undefined);
  assert.strictEqual(b.userData.email, 'a@b.nl');
});

t('lead: unique identifier is auto-mapped from the event data', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: Object.assign({}, leadEvent, { unique_identifier: 'form-sub-1' })
  }).requests[0].body;
  assert.strictEqual(b.uniqueIdentifier, 'form-sub-1');
});

t('lead: a manual unique identifier wins over the auto-mapped one', () => {
  const b = run({ tagType: 'lead', projectId: 'p1',
    userDataFields: [{ key: 'uniqueIdentifier', value: 'manual' }] }, {
    eventData: Object.assign({}, leadEvent, { unique_identifier: 'auto' })
  }).requests[0].body;
  assert.strictEqual(b.uniqueIdentifier, 'manual');
});

t('lead: no unique identifier is sent when nothing provides one', () => {
  const b = run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent }).requests[0].body;
  assert.strictEqual('uniqueIdentifier' in b, false);
});

/* ---------- Upgrading an existing tag ---------- */
// A tag saved against the old template stores no tagType at all. It has to keep
// behaving as a Lead tag, with every configured value still reaching the API.
t('upgrade: a config without tagType still sends a lead, with its project id', () => {
  const r = run({ projectId: 'legacy-project', formName: 'Contactformulier',
                  dedupEnabled: false,
                  userDataFields: [{ key: 'email', value: 'oud@example.nl' }],
                  customDeviceData: true, deviceData: [{ key: 'ipAdress', value: '198.51.100.7' }] },
    { eventData: leadEvent });
  assert.strictEqual(r.requests.length, 1);
  const b = r.requests[0].body;
  assert.strictEqual(b.projectId, 'legacy-project');
  assert.strictEqual(b.formData.formName, 'Contactformulier');
  assert.strictEqual(b.userData.email, 'oud@example.nl');
  assert.strictEqual(b.deviceData.ipAddress, '198.51.100.7');
  assert.strictEqual(r.requests[0].url, 'https://app.leadtrackr.io/api/leads/createServerSideLead');
});

t('upgrade: only an explicit pageview tagType runs the Channel Flow Tracker', () => {
  assert.strictEqual(run({ projectId: 'p1' }, { eventData: leadEvent }).setCookies.length, 0);
  assert.strictEqual(run({ tagType: '', projectId: 'p1' }, { eventData: leadEvent }).requests.length, 1);
});

/* ---------- Cookie coverage across both payload types ---------- */
const ALL_COOKIES = {
  _gcl_aw: 'GCL.17.gclidvalue', _gcl_gb: 'GCL.17.wbraidvalue', _gcl_ag: 'GCL.17.kGBRAID$i1',
  _gcl_dc: 'GCL.17.dclidvalue', _fbc: 'fb.1.17.FBCL', _fbp: 'fb.1.17.5949',
  _uetmsclkid: '_uet561f11', _uetvid: 'uet-vid', ttclid: 'tt1', _ttp: 'ttp1',
  li_fat_id: 'li1', _scclid: 'sc-click', _scid: 'sc1', _rdt_cid: 'rdt-c', _rdt_uuid: 'rdt-u',
  _epik: 'epik1', twclid: 'tw1', __oppref: 'op1', __obref: 'ob1', _ga: 'GA1.1.9999.8888'
};
const plainEvent = { page_location: 'https://www.example.nl/bedankt', event_name: 'purchase',
                     user_agent: 'UA', ip_override: '203.0.113.9' };

t('the lead payload carries every click and browser id from the cookies', () => {
  const a = run({ tagType: 'lead', projectId: 'p1' },
    { eventData: plainEvent, cookies: ALL_COOKIES }).requests[0].body.attributionData;
  assert.strictEqual(a.gclid, 'gclidvalue');
  assert.strictEqual(a.wbraid, 'wbraidvalue');
  assert.strictEqual(a.gbraid, 'GBRAID');
  assert.strictEqual(a.dclid, 'dclidvalue');
  assert.strictEqual(a.msclkid, '561f11');
  assert.strictEqual(a.uetvid, 'uet-vid');
  assert.strictEqual(a.ttclid, 'tt1');
  assert.strictEqual(a.ttp, 'ttp1');
  assert.strictEqual(a.li_fat_id, 'li1');
  assert.strictEqual(a.scclid, 'sc-click');
  assert.strictEqual(a.scid, 'sc1');
  assert.strictEqual(a.rdt_cid, 'rdt-c');
  assert.strictEqual(a.rdt_uuid, 'rdt-u');
  assert.strictEqual(a.epik, 'epik1');
  assert.strictEqual(a.twclid, 'tw1');
  assert.strictEqual(a.oppref, 'op1');
  assert.strictEqual(a.obref, 'ob1');
  assert.strictEqual(a.fbp, 'fb.1.17.5949');
});

t('lead: carries cid, sid, conversionPage and consent', () => {
  const a = run({ tagType: 'lead', projectId: 'p1' }, {
    eventData: Object.assign({}, plainEvent, { client_id: 'c1', ga_session_id: 's1',
                                               consent_state: { ad_storage: true } })
  }).requests[0].body.attributionData;
  assert.strictEqual(a.cid, 'c1');
  assert.strictEqual(a.sid, 's1');
  assert.strictEqual(a.conversionPage, 'www.example.nl/bedankt');
  assert.deepStrictEqual(a.consent, { ad_storage: 'granted' });
});

console.log('\n' + pass + ' passed, ' + fail + ' failed');
process.exit(fail ? 1 : 0);
