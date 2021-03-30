import { useState, useEffect } from "react"
import { fecthHiringProcessPipeline, ServicesErrorMessage } from "../services"
import HiringProcessPipeline from "./HiringProcessPipeline"
import PropTypes from "prop-types"
import Spinner from "./Spinner"

const LiveHiringProcessPipeline = (props) => {
  const [jobId] = useState(props.jobId)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [job, updateJob] = useState([])

  useEffect(() => {
    if (!loading) {
      fecthHiringProcessPipeline(jobId)
        .then(updateJob, setError)
        .then(() => setLoading(true))
    }
  }, [loading, jobId])

  const handleOnChange = (newPipeline) => {
    console.debug("Broadcast new pipeline", newPipeline)
  }

  return (
    <div>
      {loading && error && <ServicesErrorMessage error={error} />}
      {loading && !error && (
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
