const axios = require('axios');
// import axios from "axios";

axios.get('https://jsonplaceholder.typicode.com/posts/1')
  .then(response => {
    console.log('GET Response Data:', response.data);
  })
  .catch(error => {
    console.error('Error making GET request:', error);
  });
