import { useState, useEffect } from "react"
import { fecthHiringProcessPipeline, ServicesErrorMessage } from "../services"
import useChannel from "../hooks/useChannel"
import HiringProcessPipeline from "./HiringProcessPipeline"
import PropTypes from "prop-types"
import Spinner from "./Spinner"

const hiringProcessPipelineReducer = (state, { event, payload }) => {
  // the second argument is the message sent over the channel
  // it will contain an event key and a payload key
  console.log("reducer", state, event, payload)
  switch (event) {
    case "move_applicant":
      return payload
    default:
      return state
  }
}

const LiveHiringProcessPipeline = (props) => {
  const [jobId] = useState(props.jobId)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)
  const [job, updateJob] = useState({
    id: jobId,
    title: "",
    pipeline: { to_meet: [], in_interview: [] },
  })
  const [pipeline, broadcast] = useChannel(
    "hiring_process_pipeline:" + jobId,
    hiringProcessPipelineReducer,
    job.pipeline
  )

  const broadcastAndUpdate = (job) => {
    updateJob(job)
    broadcast("move_applicant", job.pipeline)
  }

  useEffect(() => {
    if (!loading) {
      fecthHiringProcessPipeline(jobId)
        .then(broadcastAndUpdate, setError)
        .then(() => setLoading(true))
    }
  }, [broadcastAndUpdate, loading, jobId])

  return (
    <div>
      {loading && error && <ServicesErrorMessage error={error} />}
      {loading && !error && (
        <HiringProcessPipeline
          id={job.id}
          title={job.title}
          pipeline={pipeline}
          onChange={(newPipeline) => broadcast("move_applicant", newPipeline)}
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
