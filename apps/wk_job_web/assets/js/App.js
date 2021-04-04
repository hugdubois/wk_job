import Job from "./components/Job"
import SocketProvider from "./components/SocketProvider"
import { socketUrl } from "./services"

function App() {
  return (
    <SocketProvider url={socketUrl}>
      <Job
        id="e76c32e7-f88e-47ce-840c-dae0d5d17f28"
        title="Stage - Account Manager"
      />
    </SocketProvider>
  )
}

export default App
