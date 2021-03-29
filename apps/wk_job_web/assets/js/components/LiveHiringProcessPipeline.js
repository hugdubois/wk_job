import { useState, useEffect } from "react"
import PropTypes from "prop-types"
import HiringProcessPipeline from "./HiringProcessPipeline"
import Spinner from "./Spinner"
import fakeData from "../fake_data"

const LiveHiringProcessPipeline = (props) => {
  const [jobId] = useState(props.jobId)
  const [loading, setLoading] = useState(false)
  const [job, updateJob] = useState([])
  console.debug("LiveHiringProcessPipeline : ", job)

  useEffect(() => {
    console.debug("Fetch job pipeline", jobId)
    if (!loading) {
      console.debug("request simulation with a javascript timeout")
      setTimeout(() => {
        updateJob(fakeData)
        setLoading(true)
      }, 3000)
    }
  }, [loading, jobId])

  const handleOnChange = (newPipeline) => {
    console.debug("Broadcast new pipeline", newPipeline)
  }

  return (
    <div>
      {loading && (
        <HiringProcessPipeline
          id={job.id}
          title={job.title}
          pipeline={job.pipeline}
          onChange={handleOnChange}
        />
      )}
      {!loading && <Spinner />}
    </div>
  )
}

LiveHiringProcessPipeline.propTypes = {
  jobId: PropTypes.string.isRequired,
}

export default LiveHiringProcessPipeline
