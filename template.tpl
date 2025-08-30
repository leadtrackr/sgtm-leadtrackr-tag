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
  "displayName": "LeadTrackr Leads API",
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
  "description": "This tag enables you to send your leads directly to LeadTrackr.io from your sGTM environment.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "projectId",
    "displayName": "Project ID",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "formSettings",
    "displayName": "Form Settings",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "formName",
        "displayName": "Form Name",
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "dedupEnabled",
        "checkboxText": "Enable Lead Deduplication",
        "simpleValueType": true
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
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "userData",
    "displayName": "User Data",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
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
    "name": "advancedSettings",
    "displayName": "Advanced Settings",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "extraInfo",
        "displayName": "If you want to overwrite the auto collected device \u0026 attribution data you need these settings. Only use when you know what you\u0027re doing ;)."
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
                "displayValue": "IP Adress"
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
                "value": "fbc",
                "displayValue": "FB Click ID (_fbc)"
              },
              {
                "value": "fbp",
                "displayValue": "FB Browser ID (_fbp)"
              },
              {
                "value": "cid",
                "displayValue": "GA4 Client ID"
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
  }
]


___SANDBOXED_JS_FOR_SERVER___

const sendHttpRequest = require('sendHttpRequest');
const getAllEventData = require('getAllEventData');
const makeTableMap = require('makeTableMap');
const JSON = require('JSON');
const log = require('logToConsole');
const getContainerVersion = require('getContainerVersion');
const getCookieValues = require('getCookieValues');
const getRequestHeader = require('getRequestHeader');
const parseUrl = require('parseUrl');
const computeEffectiveTldPlusOne = require('computeEffectiveTldPlusOne');
const generateRandom = require('generateRandom');
const getTimestampMillis = require('getTimestampMillis');
const containerVersion = getContainerVersion();
const isDebug = containerVersion.debugMode;
const decodeUriComponent = require('decodeUriComponent');
const encodeUriComponent = require('encodeUriComponent');

const postHeaders = { 'Content-Type': 'application/json' };
let postBodyData = {};

// Functie om attributiedata en deviceData uit te lezen en te mappen
function mapData(dataArray, key) {
  if (dataArray) {
    for (let i = 0; i < dataArray.length; i++) {
      if (dataArray[i].key === key) {
        return dataArray[i].value;
      }
    }
  }
  return undefined;
}

// Project ID ophalen uit data
postBodyData.projectId = data.projectId;

// FormData gedeelte
postBodyData.formData = {
  formName: data.formName || 'undefined form name' // Automatisch invullen als formName ontbreekt
};

// uniqueEventId alleen meesturen als deze niet undefined of leeg is
if (data.uniqueEventId) {
  postBodyData.formData.uniqueEventId = data.uniqueEventId;
}

// Form fields ophalen uit data.formFieldsData
if (data.formFieldsData) {
  postBodyData.formData.formFields = {};
  for (let key in data.formFieldsData) {
    postBodyData.formData.formFields[data.formFieldsData[key].key] = data.formFieldsData[key].value;
  }
}

// UserData gedeelte, automatisch mappen op basis van type veld
postBodyData.userData = {};
if (data.userDataFields) {
  for (let key in data.userDataFields) {
    postBodyData.userData[data.userDataFields[key].key] = data.userDataFields[key].value;
  }
}

// DeviceData gedeelte, met overschrijvingen als ze in data.deviceData zitten
const eventData = getAllEventData();
postBodyData.deviceData = {
  ipAdress: mapData(data.deviceData, 'ipAdress') || eventData.ip_override || '127.0.0.1',
  userAgent: mapData(data.deviceData, 'userAgent') || eventData.user_agent || getRequestHeader('User-Agent')
};

// AttributionData gedeelte, met overschrijvingen als ze in data.attributionData zitten
let fbc = getCookieValues('_fbc')[0] || eventData._fbc;
let fbp = getCookieValues('_fbp')[0] || eventData._fbp;
const url = eventData.page_location || getRequestHeader('referer');
const subDomainIndex = url ? computeEffectiveTldPlusOne(url).split('.').length - 1 : 1;

// Check of fbc in de URL aanwezig is
if (url) {
  const urlParsed = parseUrl(url);
  if (urlParsed && urlParsed.searchParams && urlParsed.searchParams.fbclid) {
    if (
      !fbc ||
      (fbc &&
        fbc.split('.')[fbc.split('.').length - 1] !==
        decodeUriComponent(urlParsed.searchParams.fbclid))
    ) {
      fbc =
        'fb.' +
        subDomainIndex +
        '.' +
        getTimestampMillis() +
        '.' +
        decodeUriComponent(urlParsed.searchParams.fbclid);
    }
  }
}

// Genereer fbp als het niet aanwezig is
if (!fbp && data.generateFbp) {
  fbp =
    'fb.' +
    subDomainIndex +
    '.' +
    getTimestampMillis() +
    '.' +
    generateRandom(1000000000, 2147483647);
}

// Google click id en wbraid vanuit URL of cookie
let gclid, wbraid;

// Controleer of de URL gedefinieerd is en probeer hem te parsen
if (url) {
  const urlParsed = parseUrl(url);

  // Controleer of urlParsed en searchParams bestaan
  if (urlParsed && urlParsed.searchParams) {
    gclid = urlParsed.searchParams.gclid;
    wbraid = urlParsed.searchParams.wbraid;
  }
}

// Als gclid of wbraid niet beschikbaar zijn in de URL, probeer de cookies te gebruiken
if (!gclid) {
  const gclAwCookie = getCookieValues('_gcl_aw')[0];
  gclid = gclAwCookie ? gclAwCookie.split('.')[2] : undefined;
}

if (!wbraid) {
  const gclGbCookie = getCookieValues('_gcl_gb')[0];
  wbraid = gclGbCookie ? gclGbCookie.split('.')[2] : undefined;
}

// Client ID ophalen uit eventData
let cid = eventData.client_id;

// Overschrijvingen uit data.attributionData als die beschikbaar zijn
postBodyData.attributionData = {
  fbc: mapData(data.attributionData, 'fbc') || fbc,
  fbp: mapData(data.attributionData, 'fbp') || fbp,
  gclid: mapData(data.attributionData, 'gclid') || gclid,
  wbraid: mapData(data.attributionData, 'wbraid') || wbraid,
  cid: mapData(data.attributionData, 'cid') || cid
};

// ChannelFlow ophalen uit de cookie of de variabele in de template
let channelFlowFinal = data.channelFlowData;

// Als de variabele niet is gevuld en er een cookie is, probeer de cookie te parsen
if (!channelFlowFinal) {
  const channelFlowCookieValue = getCookieValues('lt_channelflow')[0];
  if (channelFlowCookieValue && channelFlowCookieValue.charAt(0) === '[') {
    channelFlowFinal = JSON.parse(channelFlowCookieValue);
  }
}

// Voeg de channelFlow toe aan de postBodyData als het bestaat
if (channelFlowFinal) {
  postBodyData.channelFlow = channelFlowFinal;
}

// JSON body van de request
const postBody = JSON.stringify(postBodyData);

// Request opties instellen
let requestOptions = {
  headers: postHeaders,
  method: 'POST'
};

// Debug modus logging
if (isDebug) {
  log(JSON.stringify({
    'Name': 'LeadTrackr API Request',
    'Type': 'Request',
    'RequestUrl': 'https://app.leadtrackr.io/api/leads/createLead',
    'RequestBody': postBodyData,
  }));
}

// HTTP request versturen
sendHttpRequest('https://app.leadtrackr.io/api/leads/createLead', (statusCode, headers, body) => {
  if (isDebug) {
    log(JSON.stringify({
      'Name': 'LeadTrackr API Response',
      'Type': 'Response',
      'ResponseStatusCode': statusCode,
      'ResponseHeaders': headers,
      'ResponseBody': body,
    }));
  }

  if (statusCode >= 200 && statusCode < 300) {
    data.gtmOnSuccess();
  } else {
    data.gtmOnFailure();
  }
}, requestOptions, postBody);


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
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
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
                "string": "FPGCLAW"
              },
              {
                "type": 1,
                "string": "_gcl_gb"
              },
              {
                "type": 1,
                "string": "FPGCLGB"
              },
              {
                "type": 1,
                "string": "_ga"
              },
              {
                "type": 1,
                "string": "FPID"
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


