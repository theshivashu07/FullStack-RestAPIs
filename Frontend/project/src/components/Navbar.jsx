
import { NavLink, Link, useNavigate } from 'react-router-dom'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import {
  faHouse,
  faUsers,
  faSignInAlt,
  faUserPlus,
  faSignOutAlt,
} from '@fortawesome/free-solid-svg-icons'

import { useAuth } from '../context/AuthContext'

function Navbar() {
  const { isAuthenticated, logout } = useAuth()
  const navigate = useNavigate()

  const handleLogout = async () => {
    await logout()
    navigate('/')
  }

  const getNavClass = ({ isActive }) =>
    `btn ${isActive ? 'btn-light' : 'btn-outline-light'} btn-sm`

  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark px-3">
      <Link to="/" className="navbar-brand fw-bold">
        Project Rest APIs
      </Link>

      <div className="ms-auto d-flex flex-wrap gap-2">

        <NavLink
          to="/"
          end
          className={getNavClass}
        >
          <FontAwesomeIcon icon={faHouse} className="me-1" />
          Home
        </NavLink>

        {isAuthenticated ? (
          <>
            <NavLink
              to="/users/"
              end
              className={getNavClass}
            >
              <FontAwesomeIcon icon={faUsers} className="me-1" />
              Users
            </NavLink>

            <button
              onClick={handleLogout}
              className="btn btn-danger btn-sm"
            >
              <FontAwesomeIcon icon={faSignOutAlt} className="me-1" />
              Logout
            </button>
          </>
        ) : (
          <>
            <Link to="/security/register/" className="btn btn-success btn-sm">
              <FontAwesomeIcon icon={faUserPlus} className="me-1" />
              Register
            </Link>

            <Link to="/security/login/" className="btn btn-primary btn-sm">
              <FontAwesomeIcon icon={faSignInAlt} className="me-1" />
              Login
            </Link>
          </>
        )}

      </div>
    </nav>
  )
}

export default Navbar
