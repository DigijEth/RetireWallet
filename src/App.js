// src/App.js
import React, { useState } from "react";
import ConnectWallet from "./components/ConnectWallet";
import Dashboard from "./components/Dashboard";

const App = () => {
  const [signer, setSigner] = useState(null);

  return (
    <div>
      <h1>Retirement Base</h1>
      {signer ? (
        <Dashboard signer={signer} />
      ) : (
        <ConnectWallet onConnected={(signer) => setSigner(signer)} />
      )}
    </div>
  );
};

export default App;
