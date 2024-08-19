
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { retrieveTestbyID, retrieveMiRNAsbyID } from './ApiService'

export default function MiRNAComponent() {

    const [id, setId] = useState('mir156')
    const [message, setMsg] = useState('')
    const [hairpins, setHairpins] = useState([])

    function handleIdChange(event) {
        setId(event.target.value)
    }

    function handleSubmit() {
        retrieveMiRNAsbyID(id)
            .then(response => {
                setHairpins(response.data)
                //setHairpins(response.data) might not immediately update in react; so directly call response.data.length rather than hairpins.length
                setMsg(response.data.length + ' hairpins found for MicroRNA with ID/Order ID: ' + id)
            })
            .catch(error => {
                setMsg(error.message)
                console.log(error)
            })
    }

    return (
        <div>
            <h1>Displaying MicroRNA Hairpin Structure </h1>

            <div className="d-flex justify-content-center align-items-center" style={{ height: '10vh' }}>
                <label>MicroRNA ID/Order ID:</label>
                <input type="text" name="id" value={id} onChange={handleIdChange} className="form-control" style={{ border: '2px solid grey' }} />
                <button type="button" name="submit" onClick={handleSubmit} className="btn btn-secondary">Submit</button>

            </div>
            {message && <p className="alert alert-warning" > {message} </p>}
            <div>
                <table className="table">
                    <thead>
                        <tr>
                            <th>microRNA ID</th>
                            <th>Order ID</th>
                            <th style={{ textAlign: 'center' }} >Hairpin</th>
                        </tr>
                    </thead>
                    <tbody> {
                        hairpins.map(
                            hairpin => (
                                <tr key={hairpin.mirnaOrder}  >
                                    <td style={{ border: 'none', verticalAlign: 'middle', textAlign: 'center' }} >mir{hairpin.pureNumber}</td>
                                    <td style={{ border: 'none', verticalAlign: 'middle', textAlign: 'center' }} >{hairpin.mirnaOrder}</td>
                                    <td style={{ border: 'none' }} >{drawImage(hairpin.image)}</td>
                                </tr>
                            )
                        )
                    }
                    </tbody>

                </table>
            </div>
        </div>
    )

}


//here we access the image
function drawImage(image) {
    return (
        <div style={{ border: 'none', verticalAlign: 'middle' }} >
            <img className="image-main" id="img_1_gene" src={`data:image/png;base64, ${image}`} width="1400" height="2000" />
        </div>
    );
}


{/*
<td> <button className="btn btn-warning"  >save</button> </td>
 <th>Is Favorite?</th>
 {drawImage(image)}
onClick={() => save2Favorite(hairpin.mirnaOrder)}

   
        style={{ textAlign: 'center', display: 'inline-block' }}
*/}