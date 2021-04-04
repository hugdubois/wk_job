import { useState, useEffect } from "react"
import { fecthHiringProcessPipeline, ServicesErrorMessage } from "../services"
import useChannel from "../hooks/useChannel"
import HiringProcessPipeline from "./HiringProcessPipeline"
import PropTypes from "prop-types"
import Spinner from "./Spinner"

const hiringProcessPipelineReducer = (state, { event, payload }) => {
  // the second argument is the message sent over the channel
  // it will contain an event key and a payload key
  switch (event) {
    case "move_applicant":
      return payload
    default:
      return state
  }
}

const LiveHiringProcessPipeline = (props) => {
  const [jobId] = useState(props.jobId)
  const [pipeline, setPipeline] = useState({ to_meet: [], in_interview: [] })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const [broadcastedPipeline, broadcast] = useChannel(
    "hiring_process_pipeline:" + jobId,
    hiringProcessPipelineReducer,
    pipeline
  )

  useEffect(() => {
    if (!loading) {
      fecthHiringProcessPipeline(jobId)
        .then((pipeline) => {
          setPipeline(pipeline.data)
          setLoading(true)
        }, setError)
        .then(() => setLoading(true))
    }
  }, [jobId])

  useEffect(() => setPipeline(broadcastedPipeline), [broadcastedPipeline])

  if (!loading) return <Spinner />

  if (error) return <ServicesErrorMessage error={error} />

  return (
    <HiringProcessPipeline
      pipeline={pipeline}
      onChange={(newPipeline) => broadcast("move_applicant", newPipeline)}
    />
  )
}

LiveHiringProcessPipeline.propTypes = {
  jobId: PropTypes.string.isRequired,
}

export default LiveHiringProcessPipeline
