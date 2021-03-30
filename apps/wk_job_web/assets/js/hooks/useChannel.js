// useChannel is a custom hooks to work with phoenix channels
// for more informations see: https://medium.com/flatiron-labs/improving-ux-with-phoenix-channels-react-hooks-8e661d3a771e
//
// Usage :
//
//     import useChannel from "../hooks/useChannel"
//
//     const reducer = (state, { event, payload }) => {
//       // the second argument is the message sent over the channel
//       // it will contain an event key and a payload key
//       switch (event) {
//         case "my_event":
//           // compute the newState with the payload
//           return newSate
//         default:
//           return state
//       }
//     }
//
//     const BroadcasterButton = (props) => {
//       const [state, broadcast] = useChannel(props.channel, reducer, initialState)
//
//       return (
//         <button onClick={() => broadcast("my_event", props) }>
//           Click Me
//         </button>
//       )
//     }
//
import { useContext, useEffect, useReducer, useState } from "react"
import SocketContext from "../contexts/SocketContext"

const useChannel = (channelTopic, reducer, initialState) => {
  const socket = useContext(SocketContext)
  const [state, dispatch] = useReducer(reducer, initialState)
  const [broadcast, setBroadcast] = useState(mustJoinChannelWarning)

  useEffect(() => joinChannel(socket, channelTopic, dispatch, setBroadcast), [
    channelTopic,
    socket,
  ])

  return [state, broadcast]
}

const joinChannel = (socket, channelTopic, dispatch, setBroadcast) => {
  if (!socket) return () => {}
  const channel = socket.channel(channelTopic, { client: "browser" })

  channel.onMessage = (event, payload) => {
    dispatch({ event, payload })
    return payload
  }

  channel
    .join()
    .receive("ok", ({ messages }) =>
      console.log("successfully joined channel", messages || "")
    )
    .receive("error", ({ reason }) =>
      console.error("failed to join channel", reason)
    )

  setBroadcast(() => channel.push.bind(channel))

  return () => {
    channel.leave()
  }
}

const mustJoinChannelWarning = () => () =>
  console.warn(
    "useChannel broadcast function cannot be invoked before the channel has been joined"
  )

export default useChannel
