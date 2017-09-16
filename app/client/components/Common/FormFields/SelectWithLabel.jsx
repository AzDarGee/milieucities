import React, { Component } from 'react'

export default class SelectWithLabel extends Component {
  constructor(props) {
    super(props)
    this.handleChange = (e) => this._handleChange(e)
  }

  _handleChange(e) {
    if(this.props.onChange instanceof Function) { this.props.onChange(e.currentTarget.value) }
  }

  render() {
    return(
      <div className={`input-field ${this.props.classes}`}>
        <label htmlFor={this.props.id}>
          {this.props.label}
        </label>
        <select
          id={this.props.id}
          onChange={this.handleChange}
          defaultValue={this.props.defaultValue}
          value={this.props.value}
          name={this.props.name}
          form={this.props.form}
          disabled={this.props.disabled}
        >
          {
            this.props.options.map((option, i) => {
              return(
                <option key={`{this.props.label}-${i}`} value={option[0]}>{option[1]}</option>
              )
            })
          }
        </select>
        {
          this.props.error &&
          <div className='error-message'>{this.props.error}</div>
        }
      </div>
    )
  }
}
