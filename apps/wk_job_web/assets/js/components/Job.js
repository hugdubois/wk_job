import PropTypes from "prop-types"
import LiveHiringProcessPipeline from "./LiveHiringProcessPipeline"

const Job = ({ id, title }) => {
  return (
    <div key={id} className="hiring-process-pipeline">
      <h2 className="title">{title}</h2>
      <LiveHiringProcessPipeline jobId={id} />
    </div>
  )
}

Job.propTypes /* remove-proptypes */ = {
  id: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
}

export default Job
