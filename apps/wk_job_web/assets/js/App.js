import Applicant from "./components/Applicant"
import ListTitle from "./components/ListTitle"
import applicants from "./fake_data"

function App() {
  return (
    <div className="list-container">
      <ListTitle title="à rencontrer" count={applicants.length} />
      <ul className="list-content">
        {applicants.to_meet.map((applicant) => (
          <li key={applicant.id} className="list-item">
            <Applicant
              name={applicant.name}
              description={applicant.description}
              thumb={applicant.thumb}
            />
          </li>
        ))}
      </ul>
    </div>
  )
}

export default App
