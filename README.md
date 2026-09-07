# LeadTrackr Tag — Server-Side GTM

Send leads to [LeadTrackr](https://leadtrackr.io) from a Server-Side Google Tag Manager container, and build the visitor's Channel Flow journey server-side so no browser tag is required.

## Tag types

Pick one under **Tag Type** when you create the tag.

### Lead

Sends a lead to the LeadTrackr API. Fire it on your lead event.

- **Project ID** — from the LeadTrackr dashboard under *Settings*.
- **API Key** — from *Settings → API Integration*. The tag always posts to `createServerSideLead` and passes the key in the `X-API-Key` header. A project with an API token configured answers `401` when the key is missing or wrong, and the tag reports a failure; projects that predate API tokens still accept the request without one. Store the key in a Google Cloud Secret Manager or environment variable rather than typing it into the tag.

  A lead intake reachable with nothing but a Project ID does not belong in a server-side setup, so there is no fallback to the open `createLead` endpoint. **If you are upgrading a tag on a project that already has an API token, fill the key in before you publish.**
- **Auto-mapping** — on by default for user data, the event ID and attribution data. Anything you enter by hand always overrides the automatic value.

The tag reads the click and browser IDs for every ad channel: Google (`gclid`, `wbraid`, `gbraid`, `dclid`), Meta, Microsoft, TikTok, LinkedIn, Snapchat, Reddit, Pinterest, X and OpenAI. Each is taken from the URL parameter of the incoming page first and the platform's own cookie second. Cookies are only read, never created — an ID the tag invents is one the platform cannot match.

A server container can read more than a web one here: the `FPGCLAW`, `FPGCLGB`, `FPGCLAG` and `FPGCLDC` cookies it writes itself are HttpOnly, which is invisible to JavaScript but means nothing to a server reading request headers.

### Channel Flow Tracker (pageview/config)

Builds the `lt_channelflow` and `lt_session` cookies from this container. Fire it on every pageview event.

Two things have to be true or the cookies cannot land on your own domain:

1. The tagging server runs on a first-party subdomain of the website, e.g. `sgtm.example.com`.
2. The client handling the request returns a response to the browser. The GA4 client does.

The logic matches the web container's Channel Flow Tracker exactly — sessions rather than channel changes, the landing page per session, legacy cookie entries, the 25-entry and 3500-character limits, and the check that stops a click ID carried over by Consent Mode's `url_passthrough` from being recorded as a new paid touchpoint.

There is no reason to run this alongside the web container's tracker. Both write the same cookies in the same format, so nothing breaks, but you gain nothing and get two places to check whenever attribution looks wrong.

### Update Lead (webhook integration)

Posts an event to the custom endpoint of an integration connection, so an
existing lead can be updated and its conversion sent on. Fire it on the event
that should update the lead, typically a purchase.

- **Endpoint URL** — the custom endpoint from the connection's settings, e.g.
  `https://app.leadtrackr.io/api/integrations/custom/8b_6HW92tj1b`. It has to be
  on `app.leadtrackr.io`; the template's permissions allow that host and nothing else.
- **API Key** — the token of *this connection*, a different one from the project
  API Key the Lead tag uses. Sent in `X-API-Key`, or in whatever header name you
  configured on the connection.

The payload follows the convention LeadTrackr's extractor reads:

```json
{
  "event_id": "order-1000140158",
  "event_name": "purchase",
  "transaction_id": "1000140158",
  "value": 2370.62,
  "currency": "EUR",
  "attribution": {
    "gclid": "EAIaIQobChMI...",
    "fbp": "fb.1.1734445584314.5949...",
    "ga_cid": "811268591.1734445582",
    "ga_sid": "1787643311",
    "user_agent": "Mozilla/5.0 (Macintosh...)",
    "ip": "203.0.113.9"
  },
  "user_data": {
    "email": "jane@example.com",
    "phone_number": "0612345678",
    "address": {
      "first_name": "Jane",
      "last_name": "Jansen",
      "city": "Haarlem",
      "postal_code": "2025BL",
      "country": "NL"
    }
  }
}
```

Everything in it is auto-mapped from the incoming event and can be overridden
per field. `ga_cid` and `ga_sid` are normalised to `cid` and `sid` on arrival;
`user_agent` and `ip` are routed into the lead's device data rather than its
attribution. `event_id` also travels in the `x-event-id` header, which LeadTrackr
uses to recognise a retry of the same event. Anything the fields do not cover
goes in **Additional Fields** as extra top-level keys, which the connection's
mapping rules can read by path.

## Tag Execution Consent Settings

Both tag types can be gated on Google Consent Mode: send always (the default), only when `analytics_storage` is granted, or only when `ad_storage` is granted. The state is read from `eventData.consent_state`, otherwise from the `x-ga-gcs` signal. A container without Consent Mode is never silently switched off — a consent type the site does not set counts as absent, not denied.

Whichever setting you pick, the lead carries the observed consent state in `attributionData.consent`.

## Installation

1. In your server container go to **Templates → Tag Templates → New**, then **Import** and pick `template.tpl`.
2. Create a tag from it, choose the Tag Type and fill in the fields.
3. Verify in preview mode before you publish.

## Tests

`smoke.js` runs the template's sandboxed JS against a stub of the server sandbox. It reads the code straight out of `template.tpl`, so it always exercises what ships.

```
node smoke.js
```

## Support

Questions or problems: [support@leadtrackr.io](mailto:support@leadtrackr.io).

## Useful links

- [LeadTrackr](https://leadtrackr.io)
- [Server-side GTM as a lead source](https://leadtrackr.io/docs/lead-sources/server-side-gtm)
- [Channel Flow Tracker](https://leadtrackr.io/docs/lead-sources/channel-flow-tracker)
- [API authentication](https://leadtrackr.io/docs/api-reference/authentication)
- [Cookies LeadTrackr writes](https://leadtrackr.io/docs/reference/cookies)
