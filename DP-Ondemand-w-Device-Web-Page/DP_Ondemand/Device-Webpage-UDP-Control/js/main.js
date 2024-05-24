
//RLB - 24-05-24 Device Web page to generate buttons based on User variable OnDemandKeys value 
//pentagon1.mp4:pentagon2.mp4:pentagon3.mp4
//The generated button will send a udp command based on their assigned values sendUDPString('pentagon1.mp4')
//  Endpoint for Uservariable URL
//  http://192.168.1.34:8008/GetUserVars
//  Test strings
//pentagon1.mp4:pentagon2.mp4:pentagon3.mp4
//pentagon1.mp4:pentagon2.mp4:pentagon3.mp4:pentagon5.mp4:pentagon6.mp4:pentagon7.mp4:pentagon8.mp4:pentagon9.mp4:pentagon10.mp4
//square1.mp4:square2.mp4:square3.mp4:square5.mp4:square6.mp4:square7.mp4:square8.mp4

  document.addEventListener("DOMContentLoaded", function () {
    console.log("RLB Device Web Page 0.6")
  })


  function sendUDPString(s){
    console.log("sendUDPString");
    printObj(s);
    //$.post("/SendUDP", { key: "SendUDP", value: s } );
    $.post("/SendUDP", { value: s } );
  }


  function fetchUserVars(callback) {
    console.log("fetchUserVars");
    const sUrl = "/GetUserVars";
    fetch(sUrl)
        .then(response => response.text())
        .then(str => new window.DOMParser().parseFromString(str, "text/xml"))
        .then(data => {
          const nodes = data.getElementsByTagName('BrightSignVar');
          let keylistString = '';

          for (let i = 0; i < nodes.length; i++) {
              const name = nodes[i].getAttribute('name');
              const val = nodes[i]?.childNodes[0]?.nodeValue ?? '';

              if (name === "OnDemandKeys") {
                  keylistString = val;
                  break;
              }
          }

          const inputString = keylistString;
          const substrings = inputString.split(":");
          const container = document.getElementById('buttonsContainer');
          container.innerHTML = ''; // Clear previous buttons

          const longestString = substrings.reduce((a, b) => a.length > b.length ? a : b, '');

            substrings.forEach((substring, index) => {
              const baseName = substring.split('.')[0];
              const button = document.createElement('button');
              button.type = 'button';
              button.innerHTML = baseName;
              button.onclick = () => sendUDPString(substring);
              button.style.width = `${longestString.length + 2}ch`; // +2 for padding
              button.style.marginBottom = '10px';

              const div = document.createElement('div');
              div.id = `button${index + 1}`;
              div.appendChild(button);

              container.appendChild(div);
            });

            styleContainer(container);
            styleAdditionalElements();
            callback(keylistString);
        })
        .catch(error => {
            console.error('Error fetching user variables:', error);
        });
  }

  function styleContainer(container) {
    container.style.display = 'flex';
    container.style.flexDirection = 'column';
    container.style.alignItems = 'center';
    container.style.justifyContent = 'center';
    container.style.marginTop = '50px';
    container.style.marginBottom = '50px';
  }

  function styleAdditionalElements() {
    const buttonRefresh = document.getElementById('buttonRefresh');
    const logo = document.getElementById('logo');
    if (buttonRefresh) {
        buttonRefresh.style.marginBottom = '50px';
    }
    if (logo) {
        logo.style.marginTop = '50px';
    }
  }


  function logUserVars(keylistString) {
    console.log('Fetched User Variables for keylistString:', keylistString);
  }