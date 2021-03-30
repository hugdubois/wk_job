import LiveHiringProcessPipeline from "./components/LiveHiringProcessPipeline"
import SocketProvider from "./components/SocketProvider"
import { socketUrl } from "./services"

function App() {
  return (
    <SocketProvider url={socketUrl}>
      <LiveHiringProcessPipeline jobId="e76c32e7-f88e-47ce-840c-dae0d5d17f28" />
    </SocketProvider>
  )
}

export default App
