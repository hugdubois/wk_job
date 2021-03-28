import { DragDropContext } from "react-beautiful-dnd"
import { useState } from "react"
import DroppableApplicantsList from "./components/DroppableApplicantsList"
import fakeData from "./fake_data"

const reorder = (list, startIndex, endIndex) => {
  const result = Array.from(list)
  const [removed] = result.splice(startIndex, 1)
  result.splice(endIndex, 0, removed)

  return result
}

const move = (source, destination, droppableSource, droppableDestination) => {
  const sourceClone = Array.from(source)
  const destClone = Array.from(destination)
  const [removed] = sourceClone.splice(droppableSource.index, 1)

  destClone.splice(droppableDestination.index, 0, removed)

  const result = {}
  result[droppableSource.droppableId] = sourceClone
  result[droppableDestination.droppableId] = destClone

  return result
}

function App() {
  const [applicants, updateApplicants] = useState(fakeData)

  const handleOnDragEnd = (result) => {
    const { source, destination } = result
    if (!destination) return
    if (source.droppableId === destination.droppableId) {
      const items = reorder(
        applicants[source.droppableId],
        source.index,
        destination.index
      )
      if (source.droppableId === "to_meet") {
        updateApplicants({
          to_meet: items,
          in_interview: applicants.in_interview,
        })
      } else {
        updateApplicants({ to_meet: applicants.to_meet, in_interview: items })
      }
    } else {
      const newApplicants = move(
        applicants[source.droppableId],
        applicants[destination.droppableId],
        source,
        destination
      )
      updateApplicants(newApplicants)
    }
  }

  return (
    <DragDropContext onDragEnd={handleOnDragEnd}>
      <DroppableApplicantsList
        id="to_meet"
        title="à rencontrer"
        items={applicants.to_meet}
      />
      <DroppableApplicantsList
        id="in_interview"
        title="entretien"
        items={applicants.in_interview}
      />
    </DragDropContext>
  )
}

export default App
