import axios from "axios";

const api = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL,
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