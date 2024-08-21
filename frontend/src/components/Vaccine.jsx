// React Frontend: A button that triggers the Lambda function and displays the EC2 instance status.
// Create a React component with a button that triggers the Lambda function and checks the EC2 instance status.

import React, { useState, useEffect } from 'react';
import axios from 'axios';

const JupyterButton = () => {
  const [loading, setLoading] = useState(false);
  const [ec2Status, setEc2Status] = useState('stopped'); // 'running' or 'stopped'
  const [jupyterUrl, setJupyterUrl] = useState('');

  useEffect(() => {
    // Check EC2 status on component mount
    checkEc2Status();
  }, []);

  const checkEc2Status = async () => {
    try {
      const response = await axios.get('/api/check-ec2-status');
      setEc2Status(response.data.status);
    } catch (error) {
      console.error('Error checking EC2 status:', error);
    }
  };

  const handleButtonClick = async () => {
    setLoading(true);
    try {
      const response = await axios.post('/api/start-jupyter');
      setJupyterUrl(response.data.url);
      setEc2Status('running');
    } catch (error) {
      console.error('Error starting Jupyter:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h1>Vaccine page </h1>
      <button onClick={handleButtonClick} disabled={loading || ec2Status === 'running'}>
        {loading ? 'Loading...' : ec2Status === 'running' ? 'EC2 Running' : 'Start Jupyter'}
      </button>
      {jupyterUrl && <p>Jupyter URL: <a href={jupyterUrl} target="_blank" rel="noopener noreferrer">{jupyterUrl}</a></p>}
    </div>
  );
};

export default JupyterButton;

