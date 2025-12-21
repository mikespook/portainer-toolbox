let dictionary = { text: {}, placeholder: {}, title: {}, alt: {} };

// Function to request the dictionary from the background script
async function getDictionaryFromBackground() {
	try {
		const response = await chrome.runtime.sendMessage({ action: 'getDictionary' });
		if (response && response.dictionary) {
			// Ensure all dictionary sections exist to prevent undefined errors
			dictionary.text = response.dictionary.text || {};
			dictionary.placeholder = response.dictionary.placeholder || {};
			dictionary.title = response.dictionary.title || {};
			dictionary.alt = response.dictionary.alt || {};
			console.log('Dictionary received from background script.', dictionary);
		}
	} catch (error) {
		console.error('Error getting dictionary from background script:', error);
	}
}

// Function to translate regular text content
function translateTextContent(node) {
	if (node.nodeType === Node.TEXT_NODE) {
		if (node.parentNode?.nodeName !== 'SCRIPT' && node.parentNode?.nodeName !== 'STYLE') {
			let content = node.textContent;
			for (const [english, chinese] of Object.entries(dictionary.text || {})) {
				// Escape special regex characters in the english text to handle punctuation
				const escapedEnglish = english.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
				const regex = new RegExp(escapedEnglish, 'gi');
				content = content.replace(regex, chinese);
			}
			if (content !== node.textContent) {
				console.log(`Replaced text "${node.textContent}" with "${content}"`);
				node.textContent = content;
			}
		}
	}
	else {
		for (const child of node.childNodes) {
			translateTextContent(child);
		}
	}
}

// Function to translate placeholder attributes
function translatePlaceholders(node) {
	if (node.nodeType === Node.ELEMENT_NODE) {
		// Handle placeholder attributes
		if (node.hasAttribute('placeholder')) {
			let placeholder = node.getAttribute('placeholder');
			for (const [english, chinese] of Object.entries(dictionary.placeholder || {})) {
				// Escape special regex characters in the english text to handle punctuation
				const escapedEnglish = english.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
				const regex = new RegExp(escapedEnglish, 'gi');
				if (regex.test(placeholder)) {
					const newPlaceholder = placeholder.replace(regex, chinese);
					console.log(`Replaced placeholder "${placeholder}" with "${newPlaceholder}"`);
					node.setAttribute('placeholder', newPlaceholder);
					placeholder = newPlaceholder; // Update for subsequent replacements
				}
			}
		}

		// Process child nodes
		for (const child of node.childNodes) {
			translatePlaceholders(child);
		}
	}
	else {
		for (const child of node.childNodes) {
			translatePlaceholders(child);
		}
	}
}

// Function to translate title attributes
function translateTitles(node) {
	if (node.nodeType === Node.ELEMENT_NODE) {
		// Handle title attributes
		if (node.hasAttribute('title')) {
			let title = node.getAttribute('title');
			for (const [english, chinese] of Object.entries(dictionary.title || {})) {
				// Escape special regex characters in the english text to handle punctuation
				const escapedEnglish = english.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
				const regex = new RegExp(escapedEnglish, 'gi');
				if (regex.test(title)) {
					const newTitle = title.replace(regex, chinese);
					console.log(`Replaced title "${title}" with "${newTitle}"`);
					node.setAttribute('title', newTitle);
					title = newTitle; // Update for subsequent replacements
				}
			}
		}

		// Process child nodes
		for (const child of node.childNodes) {
			translateTitles(child);
		}
	}
	else {
		for (const child of node.childNodes) {
			translateTitles(child);
		}
	}
}

// Function to translate alt attributes
function translateAlts(node) {
	if (node.nodeType === Node.ELEMENT_NODE) {
		// Handle alt attributes
		if (node.hasAttribute('alt')) {
			let alt = node.getAttribute('alt');
			for (const [english, chinese] of Object.entries(dictionary.alt || {})) {
				// Escape special regex characters in the english text to handle punctuation
				const escapedEnglish = english.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
				const regex = new RegExp(escapedEnglish, 'gi');
				if (regex.test(alt)) {
					const newAlt = alt.replace(regex, chinese);
					console.log(`Replaced alt "${alt}" with "${newAlt}"`);
					node.setAttribute('alt', newAlt);
					alt = newAlt; // Update for subsequent replacements
				}
			}
		}

		// Process child nodes
		for (const child of node.childNodes) {
			translateAlts(child);
		}
	}
	else {
		for (const child of node.childNodes) {
			translateAlts(child);
		}
	}
}

// Function to translate value attributes (using text dictionary)
function translateValues(node) {
	if (node.nodeType === Node.ELEMENT_NODE) {
		// Handle value attributes
		if (node.hasAttribute('value')) {
			let value = node.getAttribute('value');
			for (const [english, chinese] of Object.entries(dictionary.text || {})) { // Using text dictionary for values
				// Escape special regex characters in the english text to handle punctuation
				const escapedEnglish = english.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
				const regex = new RegExp(escapedEnglish, 'gi');
				if (regex.test(value)) {
					const newValue = value.replace(regex, chinese);
					console.log(`Replaced value "${value}" with "${newValue}"`);
					node.setAttribute('value', newValue);
					value = newValue; // Update for subsequent replacements
				}
			}
		}

		// Process child nodes
		for (const child of node.childNodes) {
			translateValues(child);
		}
	}
	else {
		for (const child of node.childNodes) {
			translateValues(child);
		}
	}
}

// Translate all text and attributes in the document
function translateDocument() {
	// Translate text content
	translateTextContent(document.body);
	// Translate attributes
	translatePlaceholders(document.body);
	translateTitles(document.body);
	translateAlts(document.body);
	translateValues(document.body);
}

// Set up a MutationObserver to handle dynamically added content
let observer = null;

function setupObserver() {
	observer = new MutationObserver((mutations) => {
		mutations.forEach((mutation) => {
			mutation.addedNodes.forEach((node) => {
				if (node.nodeType === Node.ELEMENT_NODE) {
					// Translate the new node and its children
					translateTextContent(node);
					translatePlaceholders(node);
					translateTitles(node);
					translateAlts(node);
					translateValues(node);
					// Also translate any new child nodes that might have been added
					const walker = document.createTreeWalker(
						node,
						NodeFilter.SHOW_ELEMENT | NodeFilter.SHOW_TEXT,
						null,
						false
					);
					let currentNode;
					while (currentNode = walker.nextNode()) {
						translateTextContent(currentNode);
						translatePlaceholders(currentNode);
						translateTitles(currentNode);
						translateAlts(currentNode);
						translateValues(currentNode);
					}
				} else if (node.nodeType === Node.TEXT_NODE) {
					translateTextContent(node);
				}
			});
		});
	});

	// Start observing
	observer.observe(document.body, {
		childList: true,
		subtree: true
	});
}

// Get the dictionary and then translate the page
async function main() {
	await getDictionaryFromBackground();
	chrome.storage.sync.get(['domains'], (result) => {
		if (!result) {
			console.error("chrome.storage.sync.get returned undefined result.");
			return;
		}
		const domains = result.domains || [];
		console.log('Current domains from storage:', domains);
		const currentDomain = window.location.hostname;
		console.log('Current domain:', currentDomain);
		if (domains.some(domain => currentDomain.includes(domain))) {
			console.log('Domain matched, translating page...');
			
			// Wait for the page to fully load and render
			if (document.readyState === 'loading') {
				// Wait for DOM content to be loaded
				document.addEventListener('DOMContentLoaded', () => {
					setTimeout(() => {
						translateDocument();
						setupObserver();
					}, 1000); // Wait 1 second after DOM is loaded for frameworks to render
				});
			} else {
				// DOM is already loaded, but frameworks might still be rendering
				setTimeout(() => {
					translateDocument();
					setupObserver();
				}, 2000); // Wait 2 seconds to ensure frameworks have rendered
			}
		} else {
			console.log('No matching domain, not translating.');
		}
	});
}

main();