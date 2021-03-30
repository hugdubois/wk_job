import PropTypes from "prop-types"

const baseUrl = ""

const errorMessage = (code) => {
  switch (code) {
    case 400:
      return "Bad Request"
    case 404:
      return "Not Found"
    case 409:
      return "Conflict"
    case 422:
      return "Unprocessable Entity"
    case 500:
      return "Server Error"
    // TODO more?
    default:
      return "Unknown Error"
  }
}

/* private helpers */
const handleErrors = (resp) => {
  if (!resp.ok) {
    throw new Error(`Error ${resp.status} - ${errorMessage(resp.status)}`)
  }
  return resp.json()
}

/* Fetch functions */
export const fecthHiringProcessPipeline = (jobId) =>
  fetch(`${baseUrl}/job/${jobId}/hiring_process_pipeline`).then(handleErrors)

/* declare React components */
export const ServicesErrorMessage = (props) => {
  return (
    <div className="error-message">
      <h2>An error has occured</h2>
      <h4>{props.error.message}</h4>
    </div>
  )
}

ServicesErrorMessage.propTypes = {
  error: PropTypes.objectOf(Error),
}

export default {
  fecthHiringProcessPipeline,
  ServicesErrorMessage,
}
