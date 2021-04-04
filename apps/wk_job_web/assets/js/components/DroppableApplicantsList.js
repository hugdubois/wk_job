import { Droppable, Draggable } from "react-beautiful-dnd"
import PropTypes from "prop-types"
import Applicant from "./Applicant"
import ListTitle from "./ListTitle"
import NaturalDragAnimation from "natural-drag-animation-rbdnd"

const getListStyle = (isDraggingOver) => ({
  background: isDraggingOver ? "#eeeeee" : "#ffffff",
})

const DroppableApplicantsList = (props) => {
  return (
    <div className="list-container">
      <ListTitle title={props.title} count={props.items.length} />
      <Droppable droppableId={props.id}>
        {(provided, snapshot) => (
          <ul
            className="list-content"
            {...provided.droppableProps}
            ref={provided.innerRef}
            style={getListStyle(snapshot.isDraggingOver)}
          >
            {props.items.map((item, index) => (
              <Draggable key={item.id} draggableId={item.id} index={index}>
                {(provided, snapshot) => (
                  <NaturalDragAnimation
                    rotationMultiplier={3}
                    style={provided.draggableProps.style}
                    snapshot={snapshot}
                  >
                    {(style) => (
                      <li
                        className="list-item"
                        ref={provided.innerRef}
                        {...provided.draggableProps}
                        {...provided.dragHandleProps}
                        key={item.id}
                        style={style}
                      >
                        <Applicant
                          name={item.name}
                          description={item.description}
                          thumb={item.thumb}
                        />
                      </li>
                    )}
                  </NaturalDragAnimation>
                )}
              </Draggable>
            ))}
            {provided.placeholder}
          </ul>
        )}
      </Droppable>
    </div>
  )
}

DroppableApplicantsList.propTypes /* remove-proptypes */ = {
  id: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  items: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string.isRequired,
      description: PropTypes.string.isRequired,
      thumb: PropTypes.string.isRequired,
    })
  ).isRequired,
}

export default DroppableApplicantsList
