import React from "react"
import { Collapse, Nav, Navbar, NavbarBrand, NavItem, NavLink } from "reactstrap"
import { au3Action } from "../au3/au3"

export function AppBar() {
    return <Navbar color="light" light expand="md" style={{
        cursor: 'pointer'
    }}
        onMouseDown={(evt)=>{
            if(evt.target === evt.currentTarget.childNodes[0]){
                startMoveWindow()
            }
        }}
    >
        <NavbarBrand>Ultralight</NavbarBrand>
        <Nav className="d-flex" navbar>
            <NavItem>
                <NavLink href="#" onClick={()=>{
                    au3Action.exit()
                }}>Close</NavLink>
            </NavItem>
        </Nav>
    </Navbar>

}