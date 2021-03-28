const ListTitle = (props) => {
  return (
    <h3 className="list-title">
      {props.title}
      <span className="list-count">{props.count}</span>
    </h3>
  )
}

ListTitle.propTypes /* remove-proptypes */ = {
  title: String,
  count: Number,
}

export default ListTitle
