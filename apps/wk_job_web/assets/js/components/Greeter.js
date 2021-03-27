const Greeter = (props) => {
  return (
    <div className="greeter">
      <span className="message">{props.message}</span>
    </div>
  )
}

Greeter.propTypes /* remove-proptypes */ = {
  message: String,
}

export default Greeter
