import React from "react";
import { Link } from "react-router-dom";
import axios from 'axios';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Modal from '@mui/material/Modal';
import SettingsIcon from '@mui/icons-material/Settings';
import { IconButton } from "@mui/material";

function fetchAPI() {  
  axios.get('http://localhost:5000/hello')  
    .then(response => console.log(response.data))  
}

const style = {
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: 400,
  bgcolor: 'background.paper',
  border: '2px solid #000',
  boxShadow: 24,
  p: 4,
};

// componentDidMount() {  
//   fetchAPI();  
// }  

// render() {  
//   return (  
//     // render code here  
//   );  
// } 

export default function DebugMenu(){
    //TODO:change to save pdf + chunks and k to formdata and submit
    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData(e.target);

        fetch("file_upload", {
          method: "POST",
          body: formData
        })
          .then((response) => response.json())
          .then((data) => {
            console.log(data)
          })
          .catch((error) => {
            console.error("Error uploading form data", error)
          })

        // if (formData.password !== formData.confirmPassword) {
        //   console.log("Password and Confirm Password do not match!");
        //   return;
        // }
        // try {
        //   const response = await axios.post('http://localhost:5000/signup', formData, {
        //     headers: {
        //       'Content-Type': 'application/json'
        //     }
        //   });
        //   console.log(response.data);
        // } catch (error) {
        //   console.error('There was an error signing up!', error);
        // }
    };

    // axios.post(link_to_your_flask_app_route, formData)
    // .then(function (response) {
    //   console.log(response);
    // })
    // .catch(function (error) {
    //   console.log(error);
    // });

    //handle modal open/close
    const [open, setOpen] = React.useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);

    return(
        <div>
          <IconButton onClick={handleOpen}><SettingsIcon/></IconButton>
          <Modal
            open={open}
            onClose={handleClose}
            aria-labelledby="modal-debug-title"
            aria-describedby="modal-debug-body"
          >
            <Box sx={style}>
              <Typography id="modal-debug-title" variant="h6" component="h2">
                Debug Settings
              </Typography>
              <Typography id="modal-debug-body" sx={{ mt: 2 }}>
                <form action={handleSubmit}>
                  <label for="document">Upload document</label>
                  <input type="file" id="document"></input><br/>
                  <label for="chunksize">Chunk Size (default: 512)</label><br/>
                  <input type="number" id="chunksize"></input><br/>
                  <label for="k-val">k value (default: 3)</label><br/>
                  <input type="number" id="k-val"></input><br/>
                  <input type="submit" value="Submit"></input>
                </form>
              </Typography>
            </Box>
          </Modal>
        </div>
    )
}