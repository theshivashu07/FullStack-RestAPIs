import axios from "axios";

const api = axios.create({
    baseURL: "http://127.0.0.1:1234/api/v1",
    headers: {
        "Content-Type": "application/json",
    },
});

console.log("Axios configured base URL:", api.defaults.baseURL);

api.interceptors.request.use((config) => {
    const accessToken = sessionStorage.getItem("access_token");

    if (accessToken) {
        config.headers.Authorization = `Bearer ${accessToken}`;
    }

    console.log("Outgoing API request:", config.baseURL + config.url);

    return config;
});

export default api;