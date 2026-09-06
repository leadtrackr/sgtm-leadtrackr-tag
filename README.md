# LeadTrackr Tag — Server-Side GTM

Send leads to [LeadTrackr](https://leadtrackr.io) from a Server-Side Google Tag Manager container, and build the visitor's Channel Flow journey server-side so no browser tag is required.

## Tag types

Pick one under **Tag Type** when you create the tag.

### Lead

Sends a lead to the LeadTrackr API. Fire it on your lead event.

- **Project ID** — from the LeadTrackr dashboard under *Settings*.
- **API Key** — from *Settings → API Integration*. With a key the lead goes to the authenticated `createServerSideLead` endpoint through the `X-API-Key` header. Without one the tag falls back to the open `createLead` endpoint, which keeps older containers working but accepts leads from anyone who knows the Project ID. Store the key in a Google Cloud Secret Manager or environment variable rather than typing it into the tag.
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
