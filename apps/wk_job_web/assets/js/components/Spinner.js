import PropTypes from "prop-types"

const Spinner = (props) => {
  return (
    <div className="spinner">
      <div className="loading"></div>
      <div className="text">{props.text}</div>
    </div>
  )
}
Spinner.defaultProps = {
  text: "loading...",
}

Spinner.propTypes /* remove-proptypes */ = {
  text: PropTypes.string,
}

export default Spinner
