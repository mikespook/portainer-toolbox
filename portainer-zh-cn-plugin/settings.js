document.addEventListener('DOMContentLoaded', () => {
  const domainList = document.getElementById('domain-list');
  const newDomainInput = document.getElementById('new-domain');
  const addDomainButton = document.getElementById('add-domain');

  // Function to render the domain list
  function renderDomains(domains) {
    console.log('Rendering domains:', domains);
    domainList.innerHTML = '';
    for (const domain of domains) {
      const li = document.createElement('li');
      li.textContent = domain;
      const removeButton = document.createElement('button');
      removeButton.textContent = 'Remove';
      removeButton.addEventListener('click', () => {
        removeDomain(domain);
      });
      li.appendChild(removeButton);
      domainList.appendChild(li);
    }
  }

  // Function to add a new domain
  function addDomain() {
    const newDomain = newDomainInput.value.trim();
    if (newDomain) {
      chrome.storage.sync.get(['domains'], (result) => {
        if (!result) {
          console.error("chrome.storage.sync.get returned undefined result.");
          return;
        }
        const domains = result.domains || [];
        if (!domains.includes(newDomain)) {
          const newDomains = [...domains, newDomain];
          console.log('Adding new domains:', newDomains);
          chrome.storage.sync.set({ domains: newDomains }, () => {
            renderDomains(newDomains);
            newDomainInput.value = '';
          });
        }
      });
    }
  }

  // Function to remove a domain
  function removeDomain(domainToRemove) {
    chrome.storage.sync.get(['domains'], (result) => {
      if (!result) {
        console.error("chrome.storage.sync.get returned undefined result.");
        return;
      }
      const domains = result.domains || [];
      const newDomains = domains.filter(domain => domain !== domainToRemove);
      console.log('Removing domain, new domains:', newDomains);
      chrome.storage.sync.set({ domains: newDomains }, () => {
        renderDomains(newDomains);
      });
    });
  }

  // Initial render
  chrome.storage.sync.get(['domains'], (result) => {
    if (!result) {
      console.error("chrome.storage.sync.get returned undefined result.");
      return;
    }
    console.log('Initial render - retrieved domains:', result.domains);
    renderDomains(result.domains || []);
  });

  // Event listeners
  addDomainButton.addEventListener('click', () => {
    console.log('Add button clicked on settings page.');
    addDomain();
  });
  newDomainInput.addEventListener('keypress', (event) => {
    if (event.key === 'Enter') {
      addDomain();
    }
  });
});
