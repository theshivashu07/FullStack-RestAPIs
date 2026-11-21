import { useEffect, useState } from "react";
import authService from "../../services/authService";

function Users() {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        authService.getUsers()
            .then((response) => {
                setUsers(response.data);
            })
            .catch((err) => {
                setError(
                    err.response?.data?.detail ||
                    "Unable to fetch users."
                );
            })
            .finally(() => setLoading(false));
    }, []);

    if (loading) return <p>Loading users...</p>;
    if (error) return <p className="text-danger">{error}</p>;

    return (
        <div className="container py-4">
            <h2>Users</h2>

            <div className="row g-3">
                {users.map((user) => (
                    <div className="col-md-4" key={user.id}>
                        <div className="card p-3 h-100">
                            <h5>
                                {user.first_name} {user.last_name}
                            </h5>
                            <p className="mb-1">@{user.username}</p>
                            <p className="mb-1">{user.email}</p>
                            <p>{user.bio || "No bio available"}</p>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default Users;

