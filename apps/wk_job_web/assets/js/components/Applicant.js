const Applicant = (props) => {
  return (
    <div className="applicant">
      <div>
        <img src={props.thumb} alt={`${props.name} Thumb`} className="thumb" />
      </div>
      <p className="info">
        <span className="name">{props.name}</span>
        <span className="description">{props.description}</span>
      </p>
    </div>
  )
}

Applicant.propTypes /* remove-proptypes */ = {
  name: String,
  description: String,
  thumb: String,
}

export default Applicant
