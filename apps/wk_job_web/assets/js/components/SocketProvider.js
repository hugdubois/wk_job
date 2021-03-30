// The SocketProvider component will expect to be rendered one time at a high
// level in the component tree, much like the Redux Provider, wrapping our
// entire application for more informations see:
// https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
//
// Usage :
//
//     import SocketProvider from "./components/SocketProvider"
//
//     ...
//       <SocketProvider url="ws://localhost/socket" options={{ token }}>
//           <App />
//       </SocketProvider>
//     ...
//
import { Socket } from "phoenix"
import SocketContext from "../contexts/SocketContext"
import { useEffect, useMemo } from "react"
import PropTypes from "prop-types"

const SocketProvider = ({ url, options, children }) => {
  const socket = useMemo(() => new Socket(url, { params: options }), [
    url,
    options,
  ])

  useEffect(() => {
    socket.connect()
  }, [options, url, socket])

  return (
    <SocketContext.Provider value={socket}>{children}</SocketContext.Provider>
  )
}

SocketProvider.defaultProps = {
  options: {},
}

SocketProvider.propTypes = {
  url: PropTypes.string.isRequired,
  options: PropTypes.object,
  children: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.node),
    PropTypes.node,
  ]),
}

export default SocketProvider
