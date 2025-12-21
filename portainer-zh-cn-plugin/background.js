let dictionary = { text: {}, placeholder: {}, title: {}, alt: {} };

// Load the dictionary when the extension starts
async function loadDictionary() {
  try {
    const response = await fetch(chrome.runtime.getURL('dictionary.json'));
    dictionary = await response.json();
    console.log('Dictionary loaded in background script.', dictionary);
  } catch (error) {
    console.error('Error loading dictionary in background script:', error);
  }
}

// Listen for messages from content scripts
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'getDictionary') {
    sendResponse({ dictionary: dictionary });
  }
  return true; // Indicates that sendResponse will be called asynchronously
});

// Initialize on installation and on startup
chrome.runtime.onInstalled.addListener(() => {
  // Only set default domains if they don't already exist in storage
  chrome.storage.sync.get(['domains'], (result) => {
    if (!result.domains) {
      chrome.storage.sync.set({ domains: ['localhost', '127.0.0.1'] });
      console.log('Initialized domains to default values: localhost, 127.0.0.1.');
    } else {
      console.log('Domains already exist in storage:', result.domains);
    }
  });
  loadDictionary();
});

chrome.runtime.onStartup.addListener(() => {
  loadDictionary();
});

// Load dictionary immediately if the background script is already running
loadDictionary();
