import api from "./api";

const authService = {
    register: async (userData) => {
        const response = await api.post("/security/register/", userData);
        return response.data;
    },

    login: async (credentials) => {
        const response = await api.post("/security/login/", credentials);
        return response.data;
    },

    refreshToken: async (refreshToken) => {
        const response = await api.post("/security/token/refresh/", {
            refresh: refreshToken,
        });
        return response.data;
    },

    logout: async (refreshToken) => {
        const response = await api.post("/security/logout/", {
            refresh: refreshToken,
        });
        return response.data;
    },

    getCurrentUser: async () => {
        const response = await api.get("/users/me/");
        return response.data;
    },

    getUsers: async () => {
        const response = await api.get("/users/");
        return response.data;
    },
};

export default authService;