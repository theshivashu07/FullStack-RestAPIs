import { useState } from 'react'
import { useAuth } from '../../../context/AuthContext'
import { Link, useNavigate, useLocation } from "react-router-dom";

function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const [formData, setFormData] = useState({
    username: '',
    password: '',
  });

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const user = await login({
        username: formData.username,
        password: formData.password,
      });

      const destination = location.state?.from?.pathname || "/users/";

      navigate(destination, { replace: true });

    } catch (err) {
      console.error("LOGIN ERROR:", err);
      console.error("LOGIN RESPONSE:", err.response?.data);

      const data = err.response?.data;

      setError(
        data?.errors?.detail ||
        data?.detail ||
        data?.message ||
        "Login failed. Please try again."
      );

    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="row justify-content-center">
      <div className="col-12 col-md-8 col-lg-5">
        <div className="card border-0 shadow-sm">
          <div className="card-body p-4">
            <h2 className="fw-bold mb-4">Login</h2>

            <form onSubmit={handleLogin}>
              <div className="mb-3">
                <label className="form-label">Username</label>

                <input
                  type="text"
                  name="username"
                  className="form-control"
                  value={formData.username}
                  onChange={handleChange}
                  placeholder="Enter username"
                  required
                />
              </div>

              <div className="mb-3">
                <label className="form-label">Password</label>

                <input
                  type="password"
                  name="password"
                  className="form-control"
                  value={formData.password}
                  onChange={handleChange}
                  placeholder="Enter password"
                  required
                />
              </div>

              <button
                className="btn btn-primary w-100"
                type="submit"
                disabled={loading}
              >
                {loading ? "Signing in..." : "Login"}
              </button>

              {error && (
                <div className="alert alert-danger mt-3" role="alert">
                  {error}
                </div>
              )}
            </form>

            <p className="mt-3 mb-0 text-center">
              Don't have an account?{' '}
              <Link to="/security/register/">Register</Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Login;
