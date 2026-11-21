
import { createContext, useContext, useEffect, useState } from "react";
import authService from "../services/authService";

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    const isAuthenticated = Boolean(user);

    useEffect(() => {
        const accessToken = sessionStorage.getItem("access_token");

        if (!accessToken) {
            setLoading(false);
            return;
        }

        authService.getCurrentUser()
            .then((response) => {
                setUser(response.data);
            })
            .catch(() => {
                sessionStorage.removeItem("access_token");
                sessionStorage.removeItem("refresh_token");
                setUser(null);
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    const login = async (credentials) => {
        const response = await authService.login(credentials);
        const data = response.data;

        sessionStorage.setItem("access_token", data.access);
        sessionStorage.setItem("refresh_token", data.refresh);

        setUser(data.user);

        return data.user;
    };

    const register = async (userData) => {
        return await authService.register(userData);
    };

    const logout = async () => {
        const refreshToken = sessionStorage.getItem("refresh_token");

        try {
            if (refreshToken) {
                await authService.logout(refreshToken);
            }
        } finally {
            sessionStorage.removeItem("access_token");
            sessionStorage.removeItem("refresh_token");
            setUser(null);
        }
    };

    return (
        <AuthContext.Provider
            value={{
                user,
                loading,
                isAuthenticated,
                login,
                register,
                logout,
            }}
        >
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    return useContext(AuthContext);
}
