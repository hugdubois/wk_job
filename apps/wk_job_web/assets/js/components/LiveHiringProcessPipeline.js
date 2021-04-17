import { useState, useEffect } from "react"
import { fecthHiringProcessPipeline, ServicesErrorMessage } from "../services"
import useChannel from "../hooks/useChannel"
import HiringProcessPipeline from "./HiringProcessPipeline"
import PropTypes from "prop-types"
import Spinner from "./Spinner"

const hiringProcessPipelineReducer = (state, { event, payload }, pipeline) => {
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

  const [broadcastedChange, broadcast] = useChannel(
    "hiring_process_pipeline:" + jobId,
    hiringProcessPipelineReducer,
    {}
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

  useEffect(() => {
    if (!broadcastedChange.to) return
    const { id, from, to, position } = broadcastedChange
    const items = Array.from(pipeline[from])
    const applicant = items.find((a) => a.id === id)
    if (!applicant) return
    const fromPosition = items.indexOf(applicant)
    if (fromPosition < 0) return
    const [removed] = items.splice(fromPosition, 1)
    if (from == to) {
      items.splice(position, 0, removed)
      setPipeline({ ...pipeline, [from]: items })
    } else {
      const toClone = Array.from(pipeline[to])
      toClone.splice(position, 0, removed)
      setPipeline({ ...pipeline, [from]: items, [to]: toClone })
    }
  }, [broadcastedChange])

  if (!loading) return <Spinner />

  if (error) return <ServicesErrorMessage error={error} />

  return (
    <HiringProcessPipeline
      pipeline={pipeline}
      onChange={(applicantMovement) =>
        broadcast("move_applicant", applicantMovement)
      }
    />
  )
}

LiveHiringProcessPipeline.propTypes = {
  jobId: PropTypes.string.isRequired,
}

export default LiveHiringProcessPipeline
