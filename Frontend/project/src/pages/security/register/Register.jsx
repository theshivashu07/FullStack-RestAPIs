import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '../../../context/AuthContext'

function Register() {
    const navigate = useNavigate()
    const { register } = useAuth()

    const [error, setError] = useState("")
    const [loading, setLoading] = useState(false)

    const [formData, setFormData] = useState({
        username: '',
        first_name: '',
        last_name: '',
        email: '',
        password: '',
        confirm_password: '',
    })

    const handleChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value,
        })
    }

    const fields = [
        { name: 'username', label: 'Username', type: 'text', required: true },
        { name: 'first_name', label: 'First Name', type: 'text', required: false },
        { name: 'last_name', label: 'Last Name', type: 'text', required: false },
        { name: 'email', label: 'Email Address', type: 'email', required: true },
        { name: 'password', label: 'Password', type: 'password', required: true },
        { name: 'confirm_password', label: 'Confirm Password', type: 'password', required: true },
    ]

    const handleRegister = async (e) => {
        e.preventDefault()
        setError("")

        if (formData.password !== formData.confirm_password) {
            setError("Passwords do not match.")
            return
        }

        setLoading(true)

        try {
            const payload = {
                username: formData.username.trim(),
                email: formData.email.trim(),
                password: formData.password,
                confirm_password: formData.confirm_password,
            }

            // Optional names are sent only when provided
            if (formData.first_name.trim()) {
                payload.first_name = formData.first_name.trim()
            }

            if (formData.last_name.trim()) {
                payload.last_name = formData.last_name.trim()
            }

            await register(payload)

            navigate('/security/login/', {
                replace: true,
            })

        } catch (err) {
            console.error("REGISTER ERROR:", err)
            console.error("REGISTER RESPONSE:", err.response?.data)

            const errors = err.response?.data?.errors

            if (errors) {
                const firstError = Object.values(errors).flat()[0]
                setError(firstError || "Registration failed.")
            } else {
                setError(
                    err.response?.data?.message ||
                    "Registration failed. Please try again."
                )
            }

        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="row justify-content-center">
            <div className="col-12 col-md-9 col-lg-6">
                <div className="card border-0 shadow-sm">
                    <div className="card-body p-4">
                        <h2 className="fw-bold mb-4">Create Account</h2>

                        <form onSubmit={handleRegister}>
                            {fields.map((field) => (
                                <div className="mb-3" key={field.name}>
                                    <label className="form-label">
                                        {field.label}

                                        {field.required && (
                                            <span className="text-danger ms-1">*</span>
                                        )}
                                    </label>

                                    <input
                                        type={field.type}
                                        name={field.name}
                                        className="form-control"
                                        value={formData[field.name]}
                                        onChange={handleChange}
                                        required={field.required}
                                    />
                                </div>
                            ))}

                            <button
                                className="btn btn-success w-100"
                                type="submit"
                                disabled={loading}
                            >
                                {loading ? "Creating account..." : "Register"}
                            </button>

                            {error && (
                                <div className="alert alert-danger mt-3" role="alert">
                                    {error}
                                </div>
                            )}
                        </form>

                        <p className="mt-3 mb-0 text-center">
                            Already have an account?{' '}
                            <Link to="/security/login/">Login</Link>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Register
