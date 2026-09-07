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

/* ---------- Update Lead (webhook integration) ---------- */
const WEBHOOK = 'https://app.leadtrackr.io/api/integrations/custom/8b_6HW92tj1b';
const purchase = {
  page_location: 'https://www.example.nl/bedankt?gclid=EAIaIQobChMI',
  event_name: 'purchase',
  transaction_id: '1000140158',
  value: 2370.62,
  currency: 'EUR',
  client_id: '811268591.1734445582',
  ga_session_id: '1787643311',
  user_agent: 'Mozilla/5.0 (Macintosh)',
  ip_override: '203.0.113.9',
  user_data: {
    email: 'jane@example.com',
    phone_number: '0612345678',
    address: { first_name: 'Jane', last_name: 'Jansen', city: 'Haarlem', postal_code: '2025BL', country: 'NL' }
  }
};
const webhookCfg = { tagType: 'update', webhookUrl: WEBHOOK, webhookApiKey: 'wh_secret',
                     webhookEventId: 'order-1000140158' };

t('webhook: posts to the configured endpoint with the connection token', () => {
  const r = run(webhookCfg, { eventData: purchase, cookies: { _fbp: 'fb.1.1734445584314.5949' } });
  assert.strictEqual(r.requests[0].url, WEBHOOK);
  assert.strictEqual(r.requests[0].options.headers['X-API-Key'], 'wh_secret');
  assert.strictEqual(r.requests[0].options.headers['x-event-id'], 'order-1000140158');
  assert.strictEqual(r.success, 1);
});

t('webhook: builds the documented payload shape', () => {
  const b = run(webhookCfg, { eventData: purchase, cookies: { _fbp: 'fb.1.1734445584314.5949' } }).requests[0].body;
  assert.deepStrictEqual(b, {
    event_id: 'order-1000140158',
    event_name: 'purchase',
    transaction_id: '1000140158',
    value: 2370.62,
    currency: 'EUR',
    attribution: {
      gclid: 'EAIaIQobChMI',
      fbp: 'fb.1.1734445584314.5949',
      ga_cid: '811268591.1734445582',
      ga_sid: '1787643311',
      user_agent: 'Mozilla/5.0 (Macintosh)',
      ip: '203.0.113.9'
    },
    user_data: {
      email: 'jane@example.com',
      phone_number: '0612345678',
      address: { first_name: 'Jane', last_name: 'Jansen', city: 'Haarlem', postal_code: '2025BL', country: 'NL' }
    }
  });
});

t('webhook: value is a number, and a non-numeric one is left out', () => {
  const b1 = run(webhookCfg, { eventData: purchase }).requests[0].body;
  assert.strictEqual(typeof b1.value, 'number');
  const b2 = run(Object.assign({}, webhookCfg, { webhookValue: 'gratis' }),
    { eventData: purchase }).requests[0].body;
  assert.strictEqual('value' in b2, false);
});

t('webhook: event id falls back to the event data and rides in the header', () => {
  const r = run({ tagType: 'update', webhookUrl: WEBHOOK }, {
    eventData: Object.assign({}, purchase, { event_id: 'evt-99' })
  });
  assert.strictEqual(r.requests[0].body.event_id, 'evt-99');
  assert.strictEqual(r.requests[0].options.headers['x-event-id'], 'evt-99');
});

t('webhook: a mapped row overrides the auto-mapped value', () => {
  const b = run(Object.assign({}, webhookCfg, {
    webhookUserDataFields: [{ key: 'email', value: 'mapped@example.com' },
                            { key: 'city', value: 'Amsterdam' }],
    webhookAttributionFields: [{ key: 'gclid', value: 'mapped-gclid' }]
  }), { eventData: purchase }).requests[0].body;
  assert.strictEqual(b.user_data.email, 'mapped@example.com');
  assert.strictEqual(b.user_data.address.city, 'Amsterdam');
  assert.strictEqual(b.user_data.address.last_name, 'Jansen');
  assert.strictEqual(b.attribution.gclid, 'mapped-gclid');
});

t('webhook: auto-mapping off leaves only what was mapped by hand', () => {
  const b = run(Object.assign({}, webhookCfg, {
    autoMapWebhookUserData: false, autoMapWebhookAttribution: false, autoMapWebhookEvent: false,
    webhookUserDataFields: [{ key: 'email', value: 'only@example.com' }]
  }), { eventData: purchase }).requests[0].body;
  assert.deepStrictEqual(b.user_data, { email: 'only@example.com' });
  assert.strictEqual('attribution' in b, false);
  assert.strictEqual('event_name' in b, false);
  assert.strictEqual(b.event_id, 'order-1000140158');
});

t('webhook: additional fields land at the top level', () => {
  const b = run(Object.assign({}, webhookCfg, {
    webhookExtraFields: [{ key: 'store_id', value: 'NL-01' }]
  }), { eventData: purchase }).requests[0].body;
  assert.strictEqual(b.store_id, 'NL-01');
});

t('webhook: a custom auth header name is honoured', () => {
  const h = run(Object.assign({}, webhookCfg, { webhookAuthHeader: 'X-Shop-Token' }),
    { eventData: purchase }).requests[0].options.headers;
  assert.strictEqual(h['X-Shop-Token'], 'wh_secret');
  assert.strictEqual(h['X-API-Key'], undefined);
});

t('webhook: no endpoint url reports a failure instead of posting', () => {
  const r = run({ tagType: 'update', webhookApiKey: 'x' }, { eventData: purchase });
  assert.strictEqual(r.requests.length, 0);
  assert.strictEqual(r.failure, 1);
});

t('webhook: the consent gate applies here too', () => {
  const r = run(Object.assign({}, webhookCfg, { consentRequirement: 'ad_storage' }), {
    eventData: Object.assign({}, purchase, { consent_state: { ad_storage: false } })
  });
  assert.strictEqual(r.requests.length, 0);
  assert.strictEqual(r.success, 1);
});

t('webhook: the lead and pageview modes are untouched by the new type', () => {
  assert.strictEqual(run({ tagType: 'lead', projectId: 'p1' }, { eventData: leadEvent })
    .requests[0].url, 'https://app.leadtrackr.io/api/leads/createServerSideLead');
  assert.strictEqual(run({ tagType: 'pageview' }, { eventData: purchase }).setCookies.length, 2);
});

console.log('\n' + pass + ' passed, ' + fail + ' failed');
process.exit(fail ? 1 : 0);
