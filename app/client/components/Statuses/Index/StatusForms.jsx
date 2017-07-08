import React, { Component } from 'react'
import { render } from 'react-dom'
import EditStatus from '../Edit/Edit'
import EditMeeting from '../../Meetings/Edit/Edit'
import EditNotification from '../../Notifications/Edit/Edit'
import css from '../../Layout/Dashboard/dashboard.scss'
import i18n from '../../DevSites/Form/locale.js'
import moment from 'moment'

export default class StatusForms extends Component {
  constructor(props) {
    super(props);
    this.state = { selectedStatus: 'Application Complete, Comment Period Open' };
    this.handleUpdateStatus = (v) => this._handleUpdateStatus(v);
  }

  _handleUpdateStatus(value) {
    this.setState({ selectedStatus: value })
  }

  render() {
    return(
      <div>
        <EditStatus
          { ...this.props }
          handleUpdateStatus={this.handleUpdateStatus}
          selectedStatus={this.state.selectedStatus}
        />
        <EditMeeting
          { ...this.props }
          meeting={ this.props.status.meeting }
        />
        <EditNotification
          { ...this.props }
          notification={ this.props.status.notification }
          selectedStatus={this.state.selectedStatus}
        />
      </div>
    )
  }
}



