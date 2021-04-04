import PropTypes from "prop-types"
import LiveHiringProcessPipeline from "./LiveHiringProcessPipeline"

const Job = (props) => {
  return (
    <div key={props.id} className="hiring-process-pipeline">
      <h2 className="title">{props.title}</h2>
      <LiveHiringProcessPipeline jobId="e76c32e7-f88e-47ce-840c-dae0d5d17f28" />
    </div>
  )
}

Job.propTypes /* remove-proptypes */ = {
  id: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
}

export default Job
