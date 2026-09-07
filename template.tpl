___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "LeadTrackr Tag",
  "categories": [
    "LEAD_GENERATION",
    "CONVERSIONS",
    "ATTRIBUTION"
  ],
  "brand": {
    "displayName": "LeadTrackr.io",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAYAAAA5ZDbSAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAHySURBVHgB7dsxSgNBGEDhf7PRpMwRkht4BUtBIWrjMWwtAgEDlrmCpYUoQsRSr+AJkhuorYkZcwCLERZ2efu+YqppZt4yzcxGSJIkSZLUHkXOpLPFbBmRhqHGeDieZLXrhNAMDGdgOAPDGRjOwHAGhjMwnIHhDAxnYDgDwxkYzsBwBoYzMJyB4QwMZ2C4bs6k/bI8jAZbb7fzlLbjqEiK9NQr9y4DICvw3dHVKhrsdHH9lfUCLVOn6Hw0fc25PKLhDAxnYDgDwxkYzsBwBoYzMJyB4QwMZ2A4A8MZGM7AcAaGMzBc1oX/xcvNMCpEuUzPNX6cDvr93iAqlLuHWYG/fzbLqNDugxm1KXK3Wx7s9vA1KlOsdsMoZ6ZHNJyB4QwMZ2A4A8MZGM7AcAaGMzCcgeEMDGdgOAPDGRjOwHAGhjMwnIHhDAxnYDgDwxkYzsBwBoYzMFzWnw1NV6ZYpaJ4i4qkFO8BgQh8fzKZhv7kEQ1nYDgDwxkYzsBwBoYzMJyB4QwMZ2A4A8MZGM7AcAaGMzCcgeFqufBfbzfz8+fZZ7REijTYDbWoJXBKMY66VtwyHtFwBoYzMJyB4QwMZ2A4A8MZGM7AcAaGMzCcgeEMDGdgOAPDGRjOwHAGhst6slMUxW2oMVKK1rxnkyRJkiTpP34BF81FRmRdjK0AAAAASUVORK5CYII\u003d",
    "id": "brand_custom_template"
  },
  "description": "Send leads to LeadTrackr.io from your server-side GTM container, and build the Channel Flow journey server-side so no browser tag is needed.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "tagType",
    "displayName": "Tag Type",
    "radioItems": [
      {
        "value": "lead",
        "displayValue": "Lead"
      },
      {
        "value": "pageview",
        "displayValue": "Channel Flow Tracker (pageview/config)"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "lead",
    "help": "<b>Lead</b> sends a lead to the LeadTrackr API. Fire it on your lead event.<br/><br/>\n<b>Channel Flow Tracker</b> builds the visitor's channel journey in the <i>lt_channelflow</i> and <i>lt_session</i> cookies from this container, so the web container tag is no longer required. Fire it on every pageview event.<br/><br/>\n<b>Requirements for the server-side Channel Flow:</b> your tagging server must run on a first-party subdomain of the website (e.g. <i>sgtm.example.com</i>), and the client handling the request must return a response to the browser — the GA4 client does. Without both, the cookies cannot be written on your own domain.<br/><br/>\nDo not run this next to the web container's Channel Flow Tracker. Both write the same cookies and you gain nothing from having two.<br/><br/>\n<a href=\"https://leadtrackr.io/docs/lead-sources/channel-flow-tracker\">How Channel Flow records sessions and resolves a channel</a>"
  },
  {
    "type": "TEXT",
    "name": "projectId",
    "displayName": "Project ID",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "NOT_EQUALS"
      }
    ],
    "help": "The public ID of your LeadTrackr project. Find it in the LeadTrackr dashboard under <b>Settings</b>."
  },
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "API Key",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "NOT_EQUALS"
      }
    ],
    "help": "Required. Find it in the LeadTrackr dashboard under <b>Settings → API Integration</b>.<br/><br/>\nThe tag always posts to <i>createServerSideLead</i> and passes this key in the <i>X-API-Key</i> header. A project with an API token configured answers <b>401</b> when the key is missing or wrong, and the tag reports a failure; projects that predate API tokens still accept the request without one.<br/><br/>\n<b>Upgrading an existing tag:</b> if your project already has an API token, fill this in before you publish. The tag no longer falls back to the open <i>createLead</i> endpoint.<br/><br/>\nStore the key in a <b>Google Cloud Secret Manager</b> or environment variable rather than typing it into the tag.<br/><br/>\n<a href=\"https://leadtrackr.io/docs/api-reference/authentication\">Authenticating with the LeadTrackr API</a>"
  },
  {
    "type": "GROUP",
    "name": "formSettings",
    "displayName": "Form Settings",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "NOT_EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "formName",
        "displayName": "Form Name",
        "simpleValueType": true,
        "help": "Leave empty to inherit <i>eventData.form_name</i>, <i>eventData.formName</i> or <i>eventData.form_id</i> when auto-mapping is on."
      },
      {
        "type": "CHECKBOX",
        "name": "dedupEnabled",
        "checkboxText": "Enable Lead Deduplication",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "LeadTrackr updates an existing lead instead of creating a duplicate when it receives a <i>uniqueEventId</i> it has already seen."
      },
      {
        "type": "TEXT",
        "name": "uniqueEventId",
        "displayName": "Unique Event Id",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "dedupEnabled",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Leave empty to pick the ID up from the incoming event automatically: <i>eventData.event_id</i>, <i>eventData.eventId</i>, <i>eventData.transaction_id</i>. Anything you enter here wins."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "userData",
    "displayName": "User Data",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "NOT_EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "autoMapUserData",
        "checkboxText": "Automatically map user data from the event data",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Anything you enter in the table below always overrides the auto-mapped value.<br/><br/>\nDefault mappings:\n<ul>\n<li><b>First Name:</b> <i>eventData.first_name</i>, <i>eventData.firstName</i>, <i>eventData.user_data.first_name</i>, <i>eventData.user_data.address[].first_name</i></li>\n<li><b>Last Name:</b> <i>eventData.last_name</i>, <i>eventData.lastName</i>, <i>eventData.user_data.last_name</i>, <i>eventData.user_data.address[].last_name</i></li>\n<li><b>Email:</b> <i>eventData.email</i>, <i>eventData.email_address</i>, <i>eventData.user_data.email_address</i>, <i>eventData.user_data.email</i></li>\n<li><b>Phone Number:</b> <i>eventData.phone</i>, <i>eventData.phone_number</i>, <i>eventData.user_data.phone_number</i>, <i>eventData.user_data.phone</i></li>\n<li><b>Company Name:</b> <i>eventData.company_name</i>, <i>eventData.companyName</i>, <i>eventData.company</i>, <i>eventData.user_data.company_name</i></li>\n<li><b>Unique Identifier:</b> <i>eventData.unique_identifier</i>, <i>eventData.uniqueIdentifier</i></li>\n</ul>\n<b>Unique Identifier</b> is your own reference for this lead, for example a CRM lead ID. Max 255 characters. LeadTrackr matches on it alongside email and phone, so it belongs here rather than with the event ID. The API reads it from the top level of the body, so the tag lifts it out of <i>userData</i> for you.<br/><br/>\nHashed values (<i>sha256_email_address</i> and friends) are deliberately ignored: LeadTrackr matches and enriches on plain values, and a hash cannot be reversed into one."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "userDataFields",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "firstName",
                "displayValue": "First Name"
              },
              {
                "value": "lastName",
                "displayValue": "Last Name"
              },
              {
                "value": "phone",
                "displayValue": "Phone Number"
              },
              {
                "value": "email",
                "displayValue": "Email Address"
              },
              {
                "value": "companyName",
                "displayValue": "Company Name"
              },
              {
                "value": "uniqueIdentifier",
                "displayValue": "Unique Identifier"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT",
            "isUnique": true
          }
        ],
        "newRowButtonText": "Add Value"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "formFields",
    "displayName": "Form Fields",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "NOT_EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "formFieldsData",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "key",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add Value"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "channelFlowSettings",
    "displayName": "Channel Flow Settings",
    "groupStyle": "ZIPPY_OPEN",
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "sessionTimeoutMinutes",
        "displayName": "Session Timeout (minutes)",
        "simpleValueType": true,
        "defaultValue": 30,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "help": "How long a visitor can go without a pageview before the next visit counts as a new session. 30 minutes matches the GA4 default."
      },
      {
        "type": "CHECKBOX",
        "name": "useCustomUtm",
        "checkboxText": "Use Custom UTM Parameters",
        "simpleValueType": true,
        "help": "Only needed if your campaigns use parameter names of your own instead of <i>utm_source</i> and friends."
      },
      {
        "type": "TEXT",
        "name": "sourceParam",
        "displayName": "Source Parameter",
        "simpleValueType": true,
        "defaultValue": "utm_source",
        "enablingConditions": [
          {
            "paramName": "useCustomUtm",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "mediumParam",
        "displayName": "Medium Parameter",
        "simpleValueType": true,
        "defaultValue": "utm_medium",
        "enablingConditions": [
          {
            "paramName": "useCustomUtm",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "campaignParam",
        "displayName": "Campaign Parameter",
        "simpleValueType": true,
        "defaultValue": "utm_campaign",
        "enablingConditions": [
          {
            "paramName": "useCustomUtm",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "contentParam",
        "displayName": "Content Parameter",
        "simpleValueType": true,
        "defaultValue": "utm_content",
        "enablingConditions": [
          {
            "paramName": "useCustomUtm",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "termParam",
        "displayName": "Term Parameter",
        "simpleValueType": true,
        "defaultValue": "utm_term",
        "enablingConditions": [
          {
            "paramName": "useCustomUtm",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "overrideCookieDomain",
        "checkboxText": "Override Cookie Domain",
        "simpleValueType": true,
        "help": "By default the cookie domain is resolved from the request host. Override it if your tagging server does not sit on the same registrable domain as the website."
      },
      {
        "type": "TEXT",
        "name": "cookieDomain",
        "displayName": "Cookie Domain",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "overrideCookieDomain",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "useHttpOnlyCookie",
        "checkboxText": "Write the cookies as HttpOnly",
        "simpleValueType": true,
        "help": "Off by default so the LeadBot, the WordPress plugin and any browser-side script can still read <i>lt_channelflow</i>. Turn it on only when this container is the sole writer and reader of the journey — an HttpOnly cookie cannot be overwritten from JavaScript, which will silently break those routes.<br/><br/>\n<a href=\"https://leadtrackr.io/docs/reference/cookies\">The cookies LeadTrackr writes</a>"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "advancedSettings",
    "displayName": "Advanced Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "pageview",
        "type": "NOT_EQUALS"
      }
    ],
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "autoMapAttributionData",
        "checkboxText": "Automatically map attribution data",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Every ID is read from the URL parameter of the incoming page first and the platform's own cookie second: the parameter is the freshest copy and is there even when the pixel is absent or blocked. Cookies are only read, never created — an ID this tag invents is one the platform cannot match.<br/><br/>\nDefault mappings:\n<ul>\n<li><b>gclid / wbraid / gbraid / dclid:</b> URL parameter, then <i>_gcl_aw</i> / <i>_gcl_gb</i> / <i>_gcl_ag</i> / <i>_gcl_dc</i> and their server-written <i>FPGCL*</i> counterparts</li>\n<li><b>fbc:</b> <i>fbclid</i> URL parameter, <i>_fbc</i> cookie, <i>eventData._fbc</i>, <i>eventData.fbc</i></li>\n<li><b>fbp:</b> <i>_fbp</i> cookie, <i>eventData._fbp</i>, <i>eventData.fbp</i></li>\n<li><b>msclkid / uetvid:</b> <i>msclkid</i> URL parameter, <i>_uetmsclkid</i> and <i>_uetvid</i> cookies</li>\n<li><b>ttclid / ttp:</b> TikTok</li>\n<li><b>li_fat_id:</b> LinkedIn</li>\n<li><b>scclid / scid:</b> Snapchat</li>\n<li><b>rdt_cid / rdt_uuid:</b> Reddit</li>\n<li><b>epik:</b> Pinterest</li>\n<li><b>twclid:</b> X</li>\n<li><b>oppref / obref:</b> OpenAI</li>\n<li><b>cid / sid:</b> <i>eventData.client_id</i> and <i>eventData.ga_session_id</i></li>\n<li><b>conversionPage:</b> host and path of <i>eventData.page_location</i></li>\n<li><b>consent:</b> <i>eventData.consent_state</i>, otherwise the <i>x-ga-gcs</i> signal</li>\n</ul>"
      },
      {
        "type": "LABEL",
        "name": "extraInfo",
        "displayName": "The settings below overwrite the automatically collected data. Only use them when you know what you're doing ;)."
      },
      {
        "type": "CHECKBOX",
        "name": "customDeviceData",
        "checkboxText": "Use Custom Device Data",
        "simpleValueType": true
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "deviceData",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "ipAdress",
                "displayValue": "IP Address"
              },
              {
                "value": "userAgent",
                "displayValue": "User Agent"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add Value",
        "enablingConditions": [
          {
            "paramName": "customDeviceData",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "customAttributionData",
        "checkboxText": "Use Custom Attribution Data",
        "simpleValueType": true
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "attributionData",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "key",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "gclid",
                "displayValue": "GCLID"
              },
              {
                "value": "wbraid",
                "displayValue": "WBRAID"
              },
              {
                "value": "gbraid",
                "displayValue": "GBRAID"
              },
              {
                "value": "dclid",
                "displayValue": "DCLID"
              },
              {
                "value": "fbc",
                "displayValue": "FB Click ID (_fbc)"
              },
              {
                "value": "fbp",
                "displayValue": "FB Browser ID (_fbp)"
              },
              {
                "value": "msclkid",
                "displayValue": "Microsoft Click ID (msclkid)"
              },
              {
                "value": "uetvid",
                "displayValue": "Microsoft Visitor ID (_uetvid)"
              },
              {
                "value": "ttclid",
                "displayValue": "TikTok Click ID (ttclid)"
              },
              {
                "value": "ttp",
                "displayValue": "TikTok Browser ID (_ttp)"
              },
              {
                "value": "li_fat_id",
                "displayValue": "LinkedIn Click ID (li_fat_id)"
              },
              {
                "value": "scclid",
                "displayValue": "Snapchat Click ID (ScCid)"
              },
              {
                "value": "scid",
                "displayValue": "Snapchat Browser ID (_scid)"
              },
              {
                "value": "rdt_cid",
                "displayValue": "Reddit Click ID (rdt_cid)"
              },
              {
                "value": "rdt_uuid",
                "displayValue": "Reddit Browser ID (_rdt_uuid)"
              },
              {
                "value": "epik",
                "displayValue": "Pinterest Click ID (epik)"
              },
              {
                "value": "twclid",
                "displayValue": "X Click ID (twclid)"
              },
              {
                "value": "oppref",
                "displayValue": "OpenAI Click ID (oppref)"
              },
              {
                "value": "obref",
                "displayValue": "OpenAI Browser ID (__obref)"
              },
              {
                "value": "cid",
                "displayValue": "GA4 Client ID"
              },
              {
                "value": "sid",
                "displayValue": "GA4 Session ID"
              },
              {
                "value": "conversionPage",
                "displayValue": "Conversion Page"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT",
            "selectItems": []
          }
        ],
        "newRowButtonText": "Add Value",
        "enablingConditions": [
          {
            "paramName": "customAttributionData",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "customChannelFlowData",
        "checkboxText": "Use Custom Channel Flow Data",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "channelFlowData",
        "displayName": "Overwrite channel data",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "customChannelFlowData",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "tagExecutionConsentSettingsGroup",
    "displayName": "Tag Execution Consent Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "RADIO",
        "name": "consentRequirement",
        "radioItems": [
          {
            "value": "optional",
            "displayValue": "Send data always",
            "help": "The default. Recording a lead in LeadTrackr stands apart from your advertising tracking: the lead lands in your own project either way. Sharing it with the ad platforms is a separate step you configure inside LeadTrackr, and that step runs on the cookies and click IDs that travelled along with the lead.<br/><br/>\nWhich measurement method you are allowed to use is a legal question rather than a technical one. Check it with your privacy officer, or against your own privacy policy, before you leave this on."
          },
          {
            "value": "analytics_storage",
            "displayValue": "Only run when analytics consent is given",
            "help": "Aborts the tag when <i>analytics_storage</i> is not granted."
          },
          {
            "value": "ad_storage",
            "displayValue": "Only run when marketing consent is given",
            "help": "Aborts the tag when <i>ad_storage</i> is not granted."
          }
        ],
        "simpleValueType": true,
        "defaultValue": "optional",
        "help": "Read from Google Consent Mode: <i>eventData.consent_state</i> when the client provides it, otherwise the <i>x-ga-gcs</i> signal. When neither is present the tag runs.<br/><br/>\nThe lead itself always carries the observed consent state in <i>attributionData.consent</i>, whatever you pick here."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getAllEventData = require('getAllEventData');
const getContainerVersion = require('getContainerVersion');
const getCookieValues = require('getCookieValues');
const setCookie = require('setCookie');
const getRequestHeader = require('getRequestHeader');
const sendHttpRequest = require('sendHttpRequest');
const computeEffectiveTldPlusOne = require('computeEffectiveTldPlusOne');
const parseUrl = require('parseUrl');
const decodeUriComponent = require('decodeUriComponent');
const encodeUriComponent = require('encodeUriComponent');
const getTimestampMillis = require('getTimestampMillis');
const makeNumber = require('makeNumber');
const makeString = require('makeString');
const getType = require('getType');
const JSON = require('JSON');
const log = require('logToConsole');

const API_BASE = 'https://app.leadtrackr.io/api/leads/';

const CHANNEL_FLOW_COOKIE = 'lt_channelflow';
const SESSION_COOKIE = 'lt_session';
const CHANNEL_FLOW_MAX_AGE = 395 * 86400;
const DEFAULT_SESSION_MINUTES = 30;

// A Channel Flow entry marks the start of a session, so the array only grows
// for returning visitors. Both limits guard the 4KB browser cookie limit: past
// it the cookie is silently rejected and the whole journey is lost.
const MAX_ENTRIES = 25;
const MAX_COOKIE_LENGTH = 3500;

const SEARCH_ENGINE_LABELS = ['google', 'bing', 'yahoo', 'duckduckgo', 'baidu', 'ecosia', 'yandex', 'startpage', 'qwant', 'brave', 'naver'];
const GOOGLE_CLICK_ID_PARAMS = ['gclid', 'gbraid', 'wbraid'];

const eventData = getAllEventData();
const isDebug = !!getContainerVersion().debugMode;
const pageUrl = eventData.page_location || getRequestHeader('referer');
const pageUrlParsed = pageUrl ? parseUrl(pageUrl) : null;

if (shouldExitEarly()) {
  return data.gtmOnSuccess();
}

if (data.tagType === 'pageview') {
  updateChannelFlow();
  return data.gtmOnSuccess();
}

// An absent tagType is a tag saved before the type existed, which was a Lead.
sendLead();

/*==============================================================================
  Channel Flow
==============================================================================*/

// Returns the registrable part of a host: www.google.nl -> google.nl,
// www.google.co.uk -> google.co.uk. Matching on this instead of the full host
// is what makes every country domain resolve to the same search engine.
function registrableDomain(hostOrUrl) {
  if (!hostOrUrl) return '';
  return computeEffectiveTldPlusOne(hostOrUrl) || hostOrUrl;
}

function domainLabel(host) {
  const registrable = registrableDomain(host);
  if (!registrable) return '';
  return registrable.split('.')[0];
}

function getUtmMapping() {
  if (!data.useCustomUtm) {
    return { s: 'utm_source', m: 'utm_medium', cm: 'utm_campaign', ct: 'utm_content', tm: 'utm_term' };
  }
  return {
    s: data.sourceParam || 'utm_source',
    m: data.mediumParam || 'utm_medium',
    cm: data.campaignParam || 'utm_campaign',
    ct: data.contentParam || 'utm_content',
    tm: data.termParam || 'utm_term'
  };
}

function getUtmChannel() {
  const mapping = getUtmMapping();
  const channel = {};
  let hasAny = false;

  for (const key in mapping) {
    const value = getQueryParam(mapping[key]);
    if (isValidValue(value)) {
      channel[key] = value;
      hasAny = true;
    }
  }
  if (!hasAny) return null;

  if (!channel.s) channel.s = '(not set)';
  if (!channel.m) channel.m = '(not set)';
  return channel;
}

// Click IDs count only when present in this pageview's query string. Reading
// them from _gcl_aw would mark every later visit as paid for 90 days.
function getClickIdChannel() {
  for (let i = 0; i < GOOGLE_CLICK_ID_PARAMS.length; i++) {
    if (isValidValue(getQueryParam(GOOGLE_CLICK_ID_PARAMS[i]))) {
      return { s: 'google', m: 'cpc' };
    }
  }
  if (isValidValue(getQueryParam('msclkid'))) {
    return { s: 'bing', m: 'cpc' };
  }
  return null;
}

function getCurrentHost() {
  return (pageUrlParsed && pageUrlParsed.hostname) || '';
}

function getReferrerHost() {
  const referrer = eventData.page_referrer;
  if (!referrer) return '';
  const parsed = parseUrl(referrer);
  return (parsed && parsed.hostname) || '';
}

// An empty referrer is not internal: a real ad click can arrive without one.
function isInternalReferrer() {
  const referrerHost = getReferrerHost();
  if (!referrerHost) return false;
  return registrableDomain(referrerHost) === registrableDomain(getCurrentHost());
}

function resolveChannel(utmChannel, clickIdChannel) {
  if (utmChannel) return utmChannel;
  if (clickIdChannel) return clickIdChannel;

  const referrerHost = getReferrerHost();

  // Compared on domain level so a hop between subdomains stays internal.
  if (referrerHost && registrableDomain(referrerHost) !== registrableDomain(getCurrentHost())) {
    const label = domainLabel(referrerHost);
    for (let i = 0; i < SEARCH_ENGINE_LABELS.length; i++) {
      if (label === SEARCH_ENGINE_LABELS[i]) {
        return { s: label, m: 'organic' };
      }
    }
    return { s: referrerHost, m: 'referral' };
  }

  return { s: 'direct', m: 'none' };
}

function sameChannel(a, b) {
  if (!a || !b) return false;
  const keys = ['s', 'm', 'cm', 'ct', 'tm'];
  for (let i = 0; i < keys.length; i++) {
    if ((a[keys[i]] || '') !== (b[keys[i]] || '')) return false;
  }
  return true;
}

function getLandingPath() {
  const path = (pageUrlParsed && pageUrlParsed.pathname) || '';
  if (path.length > 100) return path.substring(0, 100);
  return path;
}

// Accepts both the compact format and the original one still living in
// cookies out in the field, so existing journeys survive the upgrade.
function toCompactEntry(entry) {
  if (!entry) return null;
  if (entry.t && entry.ch) return entry;

  if (entry.timestamp && entry.channel) {
    const legacy = entry.channel;
    const channel = {};
    if (legacy.source) channel.s = legacy.source;
    if (legacy.medium) channel.m = legacy.medium;
    if (legacy.campaign) channel.cm = legacy.campaign;
    if (legacy.content) channel.ct = legacy.content;
    if (legacy.term) channel.tm = legacy.term;
    return { t: entry.timestamp, ch: channel };
  }
  return null;
}

function readChannelFlow() {
  const cookieValues = getCookieValues(CHANNEL_FLOW_COOKIE);
  const cookieValue = (cookieValues && cookieValues.length > 0) ? cookieValues[0] : null;
  if (!cookieValue || cookieValue.charAt(0) !== '[') return [];

  const parsed = JSON.parse(cookieValue);
  if (getType(parsed) !== 'array') {
    if (isDebug) log('LeadTrackr: invalid JSON in lt_channelflow, starting a new channel flow.');
    return [];
  }

  const flow = [];
  for (let i = 0; i < parsed.length; i++) {
    const compact = toCompactEntry(parsed[i]);
    if (compact) flow.push(compact);
  }
  return flow;
}

// Always drops the second entry, never the first: the first touch is what
// makes first-touch attribution possible.
function applyLimits(flow) {
  while (flow.length > MAX_ENTRIES && flow.length > 1) {
    flow.splice(1, 1);
  }
  // The cookie is stored URL encoded, so that is the length that counts.
  while (flow.length > 1 && encodeUriComponent(JSON.stringify(flow)).length > MAX_COOKIE_LENGTH) {
    flow.splice(1, 1);
  }
  return flow;
}

function getSessionTimeoutSeconds() {
  let minutes = DEFAULT_SESSION_MINUTES;
  if (data.sessionTimeoutMinutes) {
    const parsed = makeNumber(data.sessionTimeoutMinutes);
    if (parsed && parsed > 0) minutes = parsed;
  }
  return minutes * 60;
}

function cookieOptions(maxAgeSeconds) {
  return {
    domain: (data.overrideCookieDomain && data.cookieDomain) ? data.cookieDomain : 'auto',
    path: '/',
    secure: true,
    sameSite: 'Lax',
    httpOnly: !!data.useHttpOnlyCookie,
    'max-age': maxAgeSeconds
  };
}

function updateChannelFlow() {
  const flow = readChannelFlow();
  const sessionCookie = getCookieValues(SESSION_COOKIE);
  const sessionActive = !!(sessionCookie && sessionCookie.length > 0);

  // A click ID behind an internal referrer was carried over, not clicked:
  // consent mode's url_passthrough appends it to every internal link once
  // ad_storage is denied. Without this each expired session would record
  // another paid touchpoint that never happened.
  const utmChannel = getUtmChannel();
  const clickIdChannel = isInternalReferrer() ? null : getClickIdChannel();

  const channel = resolveChannel(utmChannel, clickIdChannel);
  const hasCampaignSignal = !!utmChannel || !!clickIdChannel;
  const lastEntry = flow.length > 0 ? flow[flow.length - 1] : null;

  let isNewSession = false;
  if (!lastEntry) {
    isNewSession = true;
  } else if (!sessionActive) {
    isNewSession = true;
  } else if (hasCampaignSignal && !sameChannel(lastEntry.ch, channel)) {
    isNewSession = true;
  }

  if (isNewSession) {
    const entry = { t: getTimestampMillis(), ch: channel };
    const landingPath = getLandingPath();
    if (landingPath) entry.lp = landingPath;
    flow.push(entry);
    applyLimits(flow);
  }

  setCookie(CHANNEL_FLOW_COOKIE, JSON.stringify(flow), cookieOptions(CHANNEL_FLOW_MAX_AGE));

  // Its existence is the session signal; expiry is left to the browser.
  setCookie(SESSION_COOKIE, '1', cookieOptions(getSessionTimeoutSeconds()));

  if (isDebug) {
    log(JSON.stringify({
      Name: 'LeadTrackr Channel Flow',
      Type: 'Message',
      NewSession: isNewSession,
      SessionActive: sessionActive,
      Channel: channel,
      Entries: flow.length
    }));
  }
}

/*==============================================================================
  Lead
==============================================================================*/

function sendLead() {
  const payload = {};
  payload.projectId = data.projectId;
  payload.formData = buildFormData();
  // Always present, even when empty: the endpoint rejects a body without it.
  payload.userData = buildUserData();

  const deviceData = buildDeviceData();
  if (hasKeys(deviceData)) payload.deviceData = deviceData;

  const attributionData = buildAttributionData();
  if (hasKeys(attributionData)) payload.attributionData = attributionData;

  const channelFlow = getChannelFlowForLead();
  if (channelFlow) payload.channelFlow = channelFlow;

  const uniqueIdentifier = getUniqueIdentifier();
  if (isValidValue(uniqueIdentifier)) payload.uniqueIdentifier = makeString(uniqueIdentifier);

  // A server container always posts to the authenticated endpoint. It rejects
  // the request when the project has an API token and the header is missing,
  // which is the point: a lead intake reachable with nothing but a project ID
  // does not belong in a server-side setup.
  const useApiKey = isValidValue(data.apiKey);
  const requestUrl = API_BASE + 'createServerSideLead';

  const headers = { 'Content-Type': 'application/json' };
  if (useApiKey) headers['X-API-Key'] = data.apiKey;

  const postBody = JSON.stringify(payload);

  if (isDebug) {
    log(JSON.stringify({
      Name: 'LeadTrackr API Request',
      Type: 'Request',
      RequestUrl: requestUrl,
      Authenticated: useApiKey,
      RequestBody: payload
    }));
  }

  sendHttpRequest(requestUrl, (statusCode, responseHeaders, body) => {
    if (isDebug) {
      log(JSON.stringify({
        Name: 'LeadTrackr API Response',
        Type: 'Response',
        ResponseStatusCode: statusCode,
        ResponseHeaders: responseHeaders,
        ResponseBody: body
      }));
    }

    if (statusCode >= 200 && statusCode < 300) {
      data.gtmOnSuccess();
    } else {
      data.gtmOnFailure();
    }
  }, { headers: headers, method: 'POST' }, postBody);
}

function buildFormData() {
  const autoMap = data.autoMapUserData !== false;
  const formData = {};

  formData.formName = data.formName ||
    (autoMap ? firstValid([eventData.form_name, eventData.formName, eventData.form_id]) : undefined) ||
    'undefined form name';

  // An explicit value is always sent, as it was before. The automatic one only
  // fills in when deduplication is switched on.
  let uniqueEventId = data.uniqueEventId;
  if (!isValidValue(uniqueEventId) && data.dedupEnabled) {
    uniqueEventId = firstValid([eventData.event_id, eventData.eventId, eventData.transaction_id]);
  }
  if (isValidValue(uniqueEventId)) formData.uniqueEventId = makeString(uniqueEventId);

  const formFields = tableToObject(data.formFieldsData);
  if (hasKeys(formFields)) formData.formFields = formFields;

  return formData;
}

function buildUserData() {
  const userData = {};

  if (data.autoMapUserData !== false) {
    const sources = readEventUserData();
    const ud = sources.ud;
    const address = sources.address;

    // Hashed variants are skipped on purpose: LeadTrackr stores and matches on
    // plain values, and a sha256 field cannot be turned back into one.
    assign(userData, 'firstName', firstValid([
      eventData.first_name, eventData.firstName, eventData.nameFirst,
      ud.first_name, address.first_name
    ]));
    assign(userData, 'lastName', firstValid([
      eventData.last_name, eventData.lastName, eventData.nameLast,
      ud.last_name, address.last_name
    ]));
    assign(userData, 'email', firstValid([
      eventData.email, eventData.email_address, ud.email_address, ud.email
    ]));
    assign(userData, 'phone', firstValid([
      eventData.phone, eventData.phone_number, ud.phone_number, ud.phone
    ]));
    assign(userData, 'companyName', firstValid([
      eventData.company_name, eventData.companyName, eventData.company, ud.company_name
    ]));
  }

  const overrides = tableToObject(data.userDataFields);
  for (const key in overrides) {
    // Configured as a User Data row because that is what it identifies, but the
    // API only reads it from the top level of the body.
    if (key !== 'uniqueIdentifier') userData[key] = overrides[key];
  }

  return userData;
}

function getUniqueIdentifier() {
  const overrides = tableToObject(data.userDataFields);
  if (isValidValue(overrides.uniqueIdentifier)) return overrides.uniqueIdentifier;

  if (data.autoMapUserData !== false) {
    return firstValid([eventData.unique_identifier, eventData.uniqueIdentifier]);
  }
  return undefined;
}

function buildDeviceData() {
  const overrides = tableToObject(data.deviceData);
  const deviceData = {};

  // 'ipAdress' is the misspelled key older tag configurations still store.
  let ipAddress = overrides.ipAddress || overrides.ipAdress;
  if (!isValidValue(ipAddress) && eventData.ip_override) {
    ipAddress = makeString(eventData.ip_override).split(' ').join('').split(',')[0];
  }
  assign(deviceData, 'ipAddress', ipAddress);

  assign(deviceData, 'userAgent', overrides.userAgent || eventData.user_agent || getRequestHeader('user-agent'));

  return deviceData;
}

function buildAttributionData() {
  const overrides = tableToObject(data.attributionData);
  const attributionData = {};

  if (data.autoMapAttributionData !== false) {
    mergeInto(attributionData, collectClickIds());

    assign(attributionData, 'cid', getGa4ClientId());
    assign(attributionData, 'sid', getGa4SessionId());
    assign(attributionData, 'conversionPage', getConversionPage());

    const consentState = getConsentState();
    if (hasKeys(consentState)) attributionData.consent = consentState;
  }

  for (const key in overrides) {
    attributionData[key] = overrides[key];
  }

  return attributionData;
}

// Every click and browser id the lead carries, under LeadTrackr's own names.
function collectClickIds() {
  const ids = {};

  assign(ids, 'gclid', googleClickId('gclid', ['_gcl_aw', 'FPGCLAW']));
  assign(ids, 'wbraid', googleClickId('wbraid', ['_gcl_gb', 'FPGCLGB']));
  assign(ids, 'gbraid', googleClickId('gbraid', ['_gcl_ag', 'FPGCLAG']));
  // Collected but not actionable: Google Ads' ClickConversion takes gclid,
  // gbraid or wbraid only. dclid belongs to Campaign Manager 360 and DV360.
  assign(ids, 'dclid', googleClickId('dclid', ['_gcl_dc', 'FPGCLDC']));

  assign(ids, 'fbc', getFbc());
  assign(ids, 'fbp', firstValid([
    getCookieValues('_fbp')[0], (eventData.common_cookie || {})._fbp, eventData._fbp, eventData.fbp
  ]));

  // UET's browser pixel writes the cookie's own name into its value, so
  // '_uet561f11...' has to be sent as '561f11...'.
  let msclkid = firstOf('msclkid', ['_uetmsclkid']);
  if (msclkid && msclkid.indexOf('_uet') === 0) msclkid = msclkid.substring(4);
  assign(ids, 'msclkid', msclkid);
  assign(ids, 'uetvid', firstOf('', ['_uetvid']));

  assign(ids, 'ttclid', firstOf('ttclid', ['ttclid']));
  assign(ids, 'ttp', firstOf('', ['_ttp']));
  assign(ids, 'li_fat_id', firstOf('li_fat_id', ['li_fat_id']));
  // Snapchat capitalises its parameter where nobody else does.
  assign(ids, 'scclid', firstOf('ScCid', ['_scclid']));
  assign(ids, 'scid', firstOf('', ['_scid']));
  // rdt_cid without the underscore is what Reddit's older pixel wrote.
  assign(ids, 'rdt_cid', firstOf('rdt_cid', ['_rdt_cid', 'rdt_cid']));
  assign(ids, 'rdt_uuid', firstOf('', ['_rdt_uuid']));
  assign(ids, 'epik', firstOf('epik', ['_epik']));
  assign(ids, 'twclid', firstOf('twclid', ['twclid']));
  // OpenAI's cookies are its parameter with a __ prefix.
  assign(ids, 'oppref', firstOf('oppref', ['__oppref']));
  assign(ids, 'obref', firstOf('', ['__obref']));

  return ids;
}

function getGa4ClientId() {
  return firstValid([eventData.client_id, getGa4IdFromCookie()]);
}

function getGa4SessionId() {
  return firstValid([eventData.ga_session_id, eventData.session_id]);
}

function mergeInto(target, source) {
  for (const key in source) {
    target[key] = source[key];
  }
  return target;
}

function getFbc() {
  let fbc = firstValid([
    getCookieValues('_fbc')[0], (eventData.common_cookie || {})._fbc, eventData._fbc, eventData.fbc
  ]);

  const fbclid = getQueryParam('fbclid');
  if (!isValidValue(fbclid)) return fbc;

  const parts = fbc ? makeString(fbc).split('.') : [];
  if (!fbc || parts[parts.length - 1] !== fbclid) {
    return 'fb.' + getSubDomainIndex() + '.' + getTimestampMillis() + '.' + fbclid;
  }
  return fbc;
}

function getSubDomainIndex() {
  if (!pageUrl) return 1;
  const registrable = computeEffectiveTldPlusOne(pageUrl);
  if (!registrable) return 1;
  return registrable.split('.').length - 1;
}

// Pulls the ID out of a _gcl container. The browser tag wraps it in a
// dot-separated value whose last segment is the ID; a server-side container
// wraps it between '.k' and '$i'. No RegExp in the sandbox, so the bounds are
// found by hand. Both markers have to be there before the server format wins,
// which keeps a browser value whose ID happens to start with 'k' intact.
function unwrapGcl(value) {
  if (!value) return undefined;
  const raw = makeString(value);

  const start = raw.indexOf('.k');
  const end = raw.lastIndexOf('$i');
  if (start !== -1 && end !== -1 && end > start + 2) {
    return raw.substring(start + 2, end);
  }

  if (raw.indexOf('.') === -1) return undefined;
  const parts = raw.split('.');
  return parts[parts.length - 1];
}

// Google documents the cookie names but not which ID each one holds; mapping
// taken from stape-io/google-conversion-events-tag. gbraid is the odd one out:
// it lives in _gcl_ag rather than beside its siblings. The FPGCL* variants are
// what this container writes itself, and unlike in a web container they are
// readable here — HttpOnly means nothing to a server reading request headers.
function googleClickId(param, cookieNames) {
  const fromUrl = getQueryParam(param);
  if (isValidValue(fromUrl)) return fromUrl;

  for (let i = 0; i < cookieNames.length; i++) {
    const unwrapped = unwrapGcl(getCookieValues(cookieNames[i])[0]);
    if (isValidValue(unwrapped)) return unwrapped;
  }
  return undefined;
}

// URL parameter first, then the cookies the platform's own pixel writes: the
// parameter is the freshest copy and is there even when the pixel is absent,
// blocked by consent, or has not written its cookie yet. Cookies are only
// read, never created — an ID we invent is one the platform cannot match, so
// an absent cookie stays absent. Browser IDs have no URL parameter for that
// same reason, and are passed an empty one below.
function firstOf(param, cookieNames) {
  if (param) {
    const fromUrl = getQueryParam(param);
    if (isValidValue(fromUrl)) return fromUrl;
  }
  for (let i = 0; i < cookieNames.length; i++) {
    const value = getCookieValues(cookieNames[i])[0];
    if (isValidValue(value)) return value;
  }
  return undefined;
}

// Falls back to the _ga cookie when the client did not resolve a client_id,
// which happens for a non-GA4 client. Format: GA1.1.<cid>.
function getGa4IdFromCookie() {
  const value = getCookieValues('_ga')[0];
  if (!value) return undefined;
  const parts = makeString(value).split('.');
  if (parts.length < 4) return undefined;
  return parts[2] + '.' + parts[3];
}

function getConversionPage() {
  if (!pageUrlParsed) return undefined;
  return (pageUrlParsed.hostname || '') + (pageUrlParsed.pathname || '');
}

function getChannelFlowForLead() {
  if (data.customChannelFlowData && isValidValue(data.channelFlowData)) {
    const custom = data.channelFlowData;
    if (getType(custom) === 'string' && custom.charAt(0) === '[') return JSON.parse(custom);
    return custom;
  }

  const flow = readChannelFlow();
  if (flow.length > 0) return flow;

  // A container that never runs the Channel Flow Tracker can still receive the
  // journey on the event itself.
  const fromEvent = eventData.channelFlow || eventData.lt_channelflow;
  if (getType(fromEvent) === 'array') return fromEvent;
  if (getType(fromEvent) === 'string' && fromEvent.charAt(0) === '[') return JSON.parse(fromEvent);

  return undefined;
}


/*==============================================================================
  Consent
==============================================================================*/

// Observational only: the CMP is responsible for blocking, this records what
// the state was at the moment the lead came in.
function getConsentState() {
  const state = {};

  const consentState = eventData.consent_state;
  if (getType(consentState) === 'object') {
    for (const key in consentState) {
      state[key] = consentState[key] ? 'granted' : 'denied';
    }
    return state;
  }

  // x-ga-gcs is a string like 'G111': position 2 is ad_storage, 3 analytics.
  const gcs = makeString(eventData['x-ga-gcs'] || '');
  if (gcs.length >= 4) {
    state.ad_storage = gcs.charAt(2) === '1' ? 'granted' : 'denied';
    state.analytics_storage = gcs.charAt(3) === '1' ? 'granted' : 'denied';
  }
  return state;
}

// A consent type the site never sets is absent rather than denied, so a
// container without Consent Mode is not silently switched off.
function isConsentGivenOrNotRequired() {
  const required = data.consentRequirement;
  if (!required || required === 'optional') return true;

  const state = getConsentState();
  if (!state.hasOwnProperty(required)) return true;
  return state[required] === 'granted';
}

function shouldExitEarly() {
  if (!isConsentGivenOrNotRequired()) {
    if (isDebug) log('LeadTrackr: aborted, ' + data.consentRequirement + ' consent is not granted.');
    return true;
  }
  if (pageUrl && pageUrl.lastIndexOf('https://gtm-msr.appspot.com/', 0) === 0) return true;
  return false;
}

/*==============================================================================
  Helpers
==============================================================================*/

function getQueryParam(name) {
  if (!name || !pageUrlParsed || !pageUrlParsed.searchParams) return undefined;

  let value = pageUrlParsed.searchParams[name];
  if (getType(value) === 'array') value = value[0];
  if (!isValidValue(value)) return undefined;

  return decodeUriComponent(makeString(value));
}


function isValidValue(value) {
  const valueType = getType(value);
  if (valueType === 'null' || valueType === 'undefined') return false;
  return value !== '' && value !== 'undefined' && value !== 'null';
}

function assign(target, key, value) {
  if (isValidValue(value)) target[key] = value;
}

function hasKeys(obj) {
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) return true;
  }
  return false;
}

// A blank row is left out rather than written as an empty string, so an
// unfilled override never wipes an automatically mapped value.
function tableToObject(table) {
  const result = {};
  if (getType(table) !== 'array') return result;

  for (let i = 0; i < table.length; i++) {
    const row = table[i];
    if (row && isValidValue(row.key) && isValidValue(row.value)) {
      result[row.key] = row.value;
    }
  }
  return result;
}

// Reads a user_data object the same way whether its address arrives as an
// array or a plain object.
function readEventUserData() {
  let ud = {};
  let address = {};
  if (getType(eventData.user_data) === 'object') {
    ud = eventData.user_data;
    const addressType = getType(ud.address);
    if (addressType === 'array') address = ud.address[0] || {};
    else if (addressType === 'object') address = ud.address;
  }
  return { ud: ud, address: address };
}

function firstValid(values) {
  for (let i = 0; i < values.length; i++) {
    if (isValidValue(values[i])) return values[i];
  }
  return undefined;
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://app.leadtrackr.io/"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "referer"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "user-agent"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "_fbc"
              },
              {
                "type": 1,
                "string": "_fbp"
              },
              {
                "type": 1,
                "string": "_gcl_aw"
              },
              {
                "type": 1,
                "string": "_gcl_gb"
              },
              {
                "type": 1,
                "string": "_gcl_ag"
              },
              {
                "type": 1,
                "string": "_gcl_dc"
              },
              {
                "type": 1,
                "string": "FPGCLAW"
              },
              {
                "type": 1,
                "string": "FPGCLGB"
              },
              {
                "type": 1,
                "string": "FPGCLAG"
              },
              {
                "type": 1,
                "string": "FPGCLDC"
              },
              {
                "type": 1,
                "string": "_uetmsclkid"
              },
              {
                "type": 1,
                "string": "_uetvid"
              },
              {
                "type": 1,
                "string": "ttclid"
              },
              {
                "type": 1,
                "string": "_ttp"
              },
              {
                "type": 1,
                "string": "li_fat_id"
              },
              {
                "type": 1,
                "string": "_scclid"
              },
              {
                "type": 1,
                "string": "_scid"
              },
              {
                "type": 1,
                "string": "_rdt_cid"
              },
              {
                "type": 1,
                "string": "rdt_cid"
              },
              {
                "type": 1,
                "string": "_rdt_uuid"
              },
              {
                "type": 1,
                "string": "_epik"
              },
              {
                "type": 1,
                "string": "twclid"
              },
              {
                "type": 1,
                "string": "__oppref"
              },
              {
                "type": 1,
                "string": "__obref"
              },
              {
                "type": 1,
                "string": "_ga"
              },
              {
                "type": 1,
                "string": "lt_channelflow"
              },
              {
                "type": 1,
                "string": "lt_session"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "lt_channelflow"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "lt_session"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___

Created on 4-9-2024, 12:55:52
