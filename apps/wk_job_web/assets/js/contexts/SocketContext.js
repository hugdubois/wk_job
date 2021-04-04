// SocketContext is a React's context to provide phoenix socket through the
// component tree without having to pass props down manually at every level
// for more informations see: https://reactjs.org/docs/context.html
import { createContext } from "react"
const SocketContext = createContext()
export default SocketContext
