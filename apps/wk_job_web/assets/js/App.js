import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd"
import { useState } from "react"
import Applicant from "./components/Applicant"
import ListTitle from "./components/ListTitle"
import fakeData from "./fake_data"

function App() {
  const [applicantsToMeet, updateApplicantsToMeet] = useState(fakeData.to_meet)
  const handleOnDragEnd = (result) => {
    if (!result.destination) return
    const items = Array.from(applicantsToMeet)
    const [reorderedItem] = items.splice(result.source.index, 1)
    items.splice(result.destination.index, 0, reorderedItem)

    updateApplicantsToMeet(items)
  }

  return (
    <DragDropContext onDragEnd={handleOnDragEnd}>
      <div className="list-container">
        <ListTitle title="à rencontrer" count={applicantsToMeet.length} />
        <Droppable droppableId="applicants">
          {(provided) => (
            <ul
              className="list-content"
              {...provided.droppableProps}
              ref={provided.innerRef}
            >
              {applicantsToMeet.map((applicant, index) => (
                <Draggable
                  key={applicant.id}
                  draggableId={applicant.id}
                  index={index}
                >
                  {(provided) => (
                    <li
                      className="list-item"
                      ref={provided.innerRef}
                      {...provided.draggableProps}
                      {...provided.dragHandleProps}
                      key={applicant.id}
                    >
                      <Applicant
                        name={applicant.name}
                        description={applicant.description}
                        thumb={applicant.thumb}
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
    </DragDropContext>
  )
}

export default App
