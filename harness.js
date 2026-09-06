// Minimal stub of the sGTM sandbox so the template logic can be exercised locally.
const fs = require('fs');
const path = require('path');
// The sandboxed JS is read straight out of the template, so the tests always
// exercise what is actually shipped.
const tpl = fs.readFileSync(path.join(__dirname, 'template.tpl'), 'utf8');
const src = tpl.split('___SANDBOXED_JS_FOR_SERVER___')[1].split('___SERVER_PERMISSIONS___')[0];

function makeSandbox(env) {
  const cookies = env.cookies || {};
  const headers = env.headers || {};
  const eventData = env.eventData || {};
  const setCookies = [];
  const logs = [];
  const requests = [];

  const api = {
    getAllEventData: () => eventData,
    getContainerVersion: () => ({ debugMode: !!env.debug }),
    getCookieValues: (name) => (cookies[name] === undefined ? [] : [cookies[name]]),
    setCookie: (name, value, options) => setCookies.push({ name, value, options }),
    getRequestHeader: (name) => headers[String(name).toLowerCase()],
    sendHttpRequest: (url, cb, options, body) => {
      requests.push({ url, options, body: JSON.parse(body) });
      cb(env.statusCode || 200, {}, '{}');
    },
    computeEffectiveTldPlusOne: (input) => {
      if (!input) return '';
      let host = input;
      if (host.indexOf('://') !== -1) host = host.split('://')[1].split('/')[0];
      const parts = host.split('.');
      if (parts.length <= 2) return host;
      const sld = ['co', 'com', 'org', 'net', 'gov', 'edu', 'ac', 'mil'];
      const take = sld.indexOf(parts[parts.length - 2]) !== -1 ? 3 : 2;
      return parts.slice(parts.length - take).join('.');
    },
    parseUrl: (url) => {
      try {
        const u = new URL(url);
        const searchParams = {};
        u.searchParams.forEach((v, k) => {
          // sGTM hands back the raw, still-encoded value.
          searchParams[k] = encodeURIComponent(v);
        });
        return { href: u.href, hostname: u.hostname, pathname: u.pathname, search: u.search, searchParams };
      } catch (e) { return undefined; }
    },
    decodeUriComponent: decodeURIComponent,
    encodeUriComponent: encodeURIComponent,
    getTimestampMillis: () => env.now || 1780000000000,
    makeNumber: Number,
    makeString: String,
    getType: (v) => {
      if (v === null) return 'null';
      if (v === undefined) return 'undefined';
      if (Array.isArray(v)) return 'array';
      return typeof v;
    },
    JSON: JSON,
    logToConsole: (...a) => logs.push(a.join(' '))
  };

  return { api, setCookies, logs, requests };
}

function run(data, env) {
  const sb = makeSandbox(env);
  const req = (name) => {
    if (!(name in sb.api)) throw new Error('unstubbed require: ' + name);
    return sb.api[name];
  };
  const result = { success: 0, failure: 0 };
  const fullData = Object.assign({
    gtmOnSuccess: () => result.success++,
    gtmOnFailure: () => result.failure++
  }, data);

  const fn = new Function('require', 'data', src);
  fn(req, fullData);
  return Object.assign(result, { setCookies: sb.setCookies, logs: sb.logs, requests: sb.requests });
}

module.exports = { run };
