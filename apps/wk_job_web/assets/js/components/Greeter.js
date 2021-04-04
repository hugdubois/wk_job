import PropTypes from "prop-types"

const Greeter = (props) => {
  return (
    <div className="greeter">
      <span className="message">{props.message}</span>
    </div>
  )
}

Greeter.propTypes /* remove-proptypes */ = {
  message: PropTypes.string.isRequired,
}

export default Greeter
