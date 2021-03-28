import PropTypes from "prop-types"
import { DragDropContext } from "react-beautiful-dnd"
import { useState } from "react"
import DroppableApplicantsList from "./DroppableApplicantsList"

// function to help us with reordering a list
// when the source and destination are the same
const reorder = (list, startIndex, endIndex) => {
  const result = Array.from(list)
  const [removed] = result.splice(startIndex, 1)
  result.splice(endIndex, 0, removed)

  return result
}

// moves an item from one list to another
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

const HiringProcessPipeline = (props) => {
  // state management
  const [applicants, updateApplicants] = useState(props.pipeline)

  // handle event on the drag end
  const handleOnDragEnd = (result) => {
    const { source, destination } = result

    if (!destination) return

    let newApplicants = applicants
    if (source.droppableId === destination.droppableId) {
      const items = reorder(
        applicants[source.droppableId],
        source.index,
        destination.index
      )
      if (source.droppableId === "to_meet") {
        newApplicants = {
          to_meet: items,
          in_interview: applicants.in_interview,
        }
      } else {
        newApplicants = { to_meet: applicants.to_meet, in_interview: items }
      }
    } else {
      newApplicants = move(
        applicants[source.droppableId],
        applicants[destination.droppableId],
        source,
        destination
      )
    }
    updateApplicants(newApplicants)

    if (typeof props.onChange === "function") props.onChange(newApplicants)
  }

  return (
    <div key={props.id} className="hiring-process-pipeline">
      <h2 className="title">{props.title}</h2>
      <div className="pipeline">
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
      </div>
    </div>
  )
}

const applicantShape = PropTypes.shape({
  name: PropTypes.string.isRequired,
  description: PropTypes.string.isRequired,
  thumb: PropTypes.string.isRequired,
})

HiringProcessPipeline.propTypes = {
  id: PropTypes.string.isRequired,
  onChange: PropTypes.func,
  title: PropTypes.string.isRequired,
  pipeline: PropTypes.shape({
    to_meet: PropTypes.arrayOf(applicantShape).isRequired,
    in_interview: PropTypes.arrayOf(applicantShape).isRequired,
  }),
}
export default HiringProcessPipeline
