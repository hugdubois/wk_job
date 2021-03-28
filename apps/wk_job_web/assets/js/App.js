import { useState } from "react"
import HiringProcessPipeline from "./components/HiringProcessPipeline"
import fakeData from "./fake_data"

function App() {
  const [job, updateJob] = useState(fakeData)

  const handleOnChange = (newPipeline) => {
    const newJob = { ...job, pipeline: newPipeline }
    updateJob(newJob)
  }

  return (
    <HiringProcessPipeline
      id={job.id}
      title={job.title}
      pipeline={job.pipeline}
      onChange={handleOnChange}
    />
  )
}

export default App
