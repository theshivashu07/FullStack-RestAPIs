import { Navigate, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

function ProtectedRoute() {
    const { isAuthenticated, loading } = useAuth();
    const location = useLocation();

    if (loading) {
        return <p className="text-center mt-5">Checking authentication...</p>;
    }

    if (!isAuthenticated) {
        return (
            <Navigate
                to="/security/login/"
                state={{ from: location }}
                replace
            />
        );
    }

    return <Outlet />;
}

export default ProtectedRoute;