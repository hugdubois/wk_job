import { Droppable, Draggable } from "react-beautiful-dnd"
import Applicant from "./Applicant"
import ListTitle from "./ListTitle"

const DroppableApplicantsList = (props) => {
  return (
    <div className="list-container">
      <ListTitle title={props.title} count={props.items.length} />
      <Droppable droppableId={props.id}>
        {(provided) => (
          <ul
            className="list-content"
            {...provided.droppableProps}
            ref={provided.innerRef}
          >
            {props.items.map((item, index) => (
              <Draggable key={item.id} draggableId={item.id} index={index}>
                {(provided) => (
                  <li
                    className="list-item"
                    ref={provided.innerRef}
                    {...provided.draggableProps}
                    {...provided.dragHandleProps}
                    key={item.id}
                  >
                    <Applicant
                      name={item.name}
                      description={item.description}
                      thumb={item.thumb}
                    />
                  </li>
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
  id: String,
  title: String,
  items: Array,
}

export default DroppableApplicantsList
