import PropTypes from "prop-types"

const ListTitle = (props) => {
  return (
    <h3 className="list-title">
      {props.title}
      <span className="list-count">{props.count}</span>
    </h3>
  )
}

ListTitle.propTypes /* remove-proptypes */ = {
  title: PropTypes.string.isRequired,
  count: PropTypes.number.isRequired,
}

export default ListTitle
