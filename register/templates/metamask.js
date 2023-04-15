document.addEventListener("DOMContentLoaded", () => {
    const connectButton = document.getElementById("connect-button");
  
    // Check if MetaMask is installed
    if (typeof window.ethereum === "undefined") {
      alert("Please install MetaMask to use this dApp!");
    }
  
    connectButton.addEventListener("click", async () => {
      try {
        // Request account access
        const accounts = await window.ethereum.request({ method: "eth_requestAccounts" });
  
        // MetaMask connection successful
        const account = accounts[0];
        console.log("Connected to account:", account);
      } catch (error) {
        console.error("MetaMask connection failed:", error);
      }
    });
  });