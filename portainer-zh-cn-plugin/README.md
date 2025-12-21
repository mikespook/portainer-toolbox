# English to Chinese Translator Plugin

This is a browser extension for Chrome and Firefox that translates English text to Chinese on specific web pages.

## How to Use

1.  **Load the extension:**
    *   **Chrome:**
        1.  Open Chrome and go to `chrome://extensions`.
        2.  Enable "Developer mode".
        3.  Click "Load unpacked" and select the directory where you saved this plugin.
    *   **Firefox:**
        1.  Open Firefox and go to `about:debugging`.
        2.  Click "This Firefox" and then "Load Temporary Add-on".
        3.  Select the `manifest.json` file.

2.  **Configure the settings:**
    *   Click on the extension's icon in the toolbar to open the settings popup.
    *   Add the domains of the websites where you want the translation to be active (e.g., `en.wikipedia.org`).

3.  **Browse:**
    *   Navigate to a website that you've added to the active domains.
    *   The English text on the page will be translated to Chinese based on the `dictionary.json` file.

## How to Customize

*   **Dictionary:**
    *   You can edit the `dictionary.json` file to add, remove, or change translations.
    *   The format is a simple JSON object with English words as keys and their Chinese translations as values.
